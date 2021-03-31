//
//  SingleUseCardFlowViewController.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 9/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import UIKit
import WebKit

final class SingleUseCardFlowViewController: UIViewController, UIAdaptivePresentationControllerDelegate {
  typealias Command = SingleUseCardLogicController.Command
  typealias Screen = SingleUseCardLogicController.Screen

  // Payload for consumer cards API request
  private let logicController: SingleUseCardLogicController

  private let completion: (_ result: SingleUseCardCheckoutResult) -> Void

  private var enterAmountViewController: EnterAmountViewController
  private let singleUseCardView: SingleUseCardView
  private let loadingView: LoadingView
  private let infoViewController: SingleUseCardInfoViewController
  private var infoBarButtonItem: UIBarButtonItem?
  private var closeBarButtonItem: UIBarButtonItem?

  init(
    with logicController: SingleUseCardLogicController,
    completion: @escaping (_ result: SingleUseCardCheckoutResult) -> Void
  ) {
    self.logicController = logicController
    self.completion = completion

    self.enterAmountViewController = EnterAmountViewController(
      aggregatorName: logicController.aggregatorName,
      merchantName: logicController.merchantName
    )
    self.singleUseCardView = SingleUseCardView(
      merchantName: "\(logicController.merchantName) via \(logicController.aggregatorName)",
      continueAction: #selector(dismissSingleUseCardFlow),
      editCancelAction: #selector(showEditCancelActionSheet)
    )
    self.loadingView = LoadingView()
    self.infoViewController = SingleUseCardInfoViewController(
      merchantName: logicController.merchantName,
      aggregator: logicController.aggregatorName
    )

    super.init(nibName: nil, bundle: nil)

    enterAmountViewController.configureEnterAmountAction(triggerCheckoutFlowAction)
    logicController.configureCommandHandler(with: { [unowned self] command in
      DispatchQueue.main.async {
        self.commandHandler(command: command)
      }
    })
    enterAmountViewController.setAmount(value: logicController.amount.amount)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if #available(iOS 13.0, *) {
      overrideUserInterfaceStyle = .light
    }

    view.backgroundColor = .white

    navigationController?.presentationController?.delegate = self

    logicController.navigateToCurrentScreen()

    setupSubViews()
    setupNavigationBar()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)

    singleUseCardView.isHidden = true
    loadingView.isHidden = true
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    singleUseCardView.isHidden = false
    loadingView.isHidden = false
  }

  private func setupSubViews() {
    singleUseCardView.backgroundColor  = view.backgroundColor
    singleUseCardView.translatesAutoresizingMaskIntoConstraints = false

    loadingView.backgroundColor = view.backgroundColor
    loadingView.frame = view.frame

    view.addSubview(singleUseCardView)
    view.addSubview(loadingView)
  }

  private func updateLayout(with subview: UIView) {
    NSLayoutConstraint.activate([
      subview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      subview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      subview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      subview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  private func setupNavigationBar() {
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = view.backgroundColor
    navigationController?.navigationBar.tintColor = .black
    navigationItem.titleView = LogoView()

    self.closeBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .stop,
      target: self,
      action: #selector(dismissSingleUseCardFlow)
    )
    navigationItem.rightBarButtonItem = closeBarButtonItem

    // Setup left bar button item
    let infoIcon = SVGView(svgConfiguration: InfoIconSVGConfiguration())
    infoIcon.frame = CGRect(x: 0, y: 0, width: 21, height: 21)

    let renderer = UIGraphicsImageRenderer(size: infoIcon.bounds.size)
    let infoIconImage = renderer.image { rendererContext in
      infoIcon.layer.render(in: rendererContext.cgContext)
    }

    self.infoBarButtonItem = UIBarButtonItem(
      image: infoIconImage,
      style: .plain,
      target: self,
      action: #selector(showInfoPage)
    )
  }

  private func updateNavigationBar(screen: Screen) {
    switch screen {
    case .initialAmount:
      navigationController?.setNavigationBarHidden(false, animated: true)
      enterAmountViewController.navigationItem.hidesBackButton = true
      enterAmountViewController.navigationItem.leftBarButtonItem = infoBarButtonItem
      enterAmountViewController.navigationItem.rightBarButtonItem = closeBarButtonItem
    case .editAmount:
      navigationController?.setNavigationBarHidden(false, animated: true)
      enterAmountViewController.navigationItem.leftBarButtonItem = nil
      enterAmountViewController.navigationItem.hidesBackButton = false
      enterAmountViewController.navigationItem.rightBarButtonItem = infoBarButtonItem
    case .loading, .checkout:
      navigationController?.setNavigationBarHidden(true, animated: true)
    case .singleUseCard:
      navigationController?.setNavigationBarHidden(false, animated: true)
      navigationItem.leftBarButtonItem = nil
    case .info:
      navigationController?.setNavigationBarHidden(false, animated: true)
      infoViewController.navigationItem.rightBarButtonItem = closeBarButtonItem
    case .cancel:
      return
    }
  }

  private func updatePresentationControllerDelegate(screen: Screen) {
    switch screen {
    case .checkout:
      return
    default:
      navigationController?.presentationController?.delegate = self
    }
  }

  private func handleAPIError(_ error: (Error)) {
    if let apiError = error as? APIPlusError, case .error(let details) = apiError {
      completion(.failed(reason: .apiError(details)))
    } else {
      completion(.failed(reason: .networkError(error)))
    }
  }

  private func commandHandler(command: Command) {
    switch command {
    case .handleError(let error):
      dismiss(animated: true) { [weak self] in
        self?.handleAPIError(error)
      }
    case .dismissOnCardCancellation:
      dismiss(animated: true) { [weak self] in
        self?.completion(.failed(reason: .cardCancelled))
      }
    case .showEditCancelActionSheet:
      showEditCancelActionSheet()
    case .dismissModalOnSuccess(let virtualCard):
      completion(.success(virtualCard: virtualCard))
    case .cancelWebCheckout(let reason):
      completion(.failed(reason: .checkoutCancelled(reason: reason)))
    case .navigateTo(let screen):
      if #available(iOS 13.0, *) {
        isModalInPresentation = screen == .loading
      }
      navigateTo(screen: screen)
      updateNavigationBar(screen: screen)
      updatePresentationControllerDelegate(screen: screen)
    }
  }

  // TODO: Extract out to separate methods
  private func navigateTo(screen: Screen) {
    if case .loading = screen {
      loadingView.startLoadingSpinner()
    } else {
      loadingView.stopLoadingSpinner()
    }

    switch screen {
    case .initialAmount(let value):
      enterAmountViewController.setAmount(value: value)
      navigationController?.setViewControllers([self, enterAmountViewController], animated: false)
    case .editAmount(let value):
      // TODO: Edit card screen should cancel existing card and create new one
      enterAmountViewController.setAmount(value: value)
      navigationController?.setViewControllers([self, enterAmountViewController], animated: true)
    case .singleUseCard:
      guard
        let card = logicController.singleUseCard.virtualCard,
        let expiry = logicController.singleUseCard.expiry
      else {
        return
      }
      singleUseCardView.updateCardDetails(with: logicController.amount, virtualCard: card, expiry: expiry)
      view.bringSubviewToFront(singleUseCardView)
      updateLayout(with: singleUseCardView)

    case .checkout(let url):
      let viewControllerToPresent = CheckoutWebViewController(
        checkoutUrl: url,
        keepModalOpenOnComplete: true,
        completion: checkoutCompletion(_:)
      )
      navigationController?.show(viewControllerToPresent, sender: self)
    case .info:
      let viewControllerToPresent = infoViewController
      navigationController?.show(viewControllerToPresent, sender: self)
    case .loading:
      view.bringSubviewToFront(loadingView)
      updateLayout(with: loadingView)
    case .cancel:
      let viewControllerToPresent = CancelCardViewController(cancelAction: confirmCancelCard)
      navigationController?.show(viewControllerToPresent, sender: self)
    }
  }

  // MARK: - UIAdaptivePresentationControllerDelegate

  func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
    logicController.dismissModal()
  }

  // MARK: - Navigation Bar Button Actions
  @objc private func dismissSingleUseCardFlow() {
    dismiss(animated: true) { [weak self] in
      self?.logicController.dismissModal()
    }
  }

  private func triggerCheckoutFlowAction() {
    let amountValue = enterAmountViewController.getAmountValue() ?? "0.00"
    logicController.loadCheckout(amountValue: amountValue)
  }

  // MARK: - Button Actions
  @objc private func showInfoPage() {
    logicController.showInfoPage()
  }

  @objc private func showEditCancelActionSheet() {
    let editCardAction = UIAlertAction(title: "Edit Card Amount", style: .default) { [weak self] _ in
      self?.logicController.showEditCardScreen()
    }
    let cancelAction = UIAlertAction(title: "Cancel Single-Use card", style: .destructive) { [weak self] _ in
      self?.logicController.showCancelCardScreen()
    }
    let continueAction = UIAlertAction(title: "Continue with purchase", style: .cancel)

    let editCancelAlert = UIAlertController(
      title: nil,
      message: nil,
      preferredStyle: .actionSheet
    )

    editCancelAlert.addAction(editCardAction)
    editCancelAlert.addAction(cancelAction)
    editCancelAlert.addAction(continueAction)

    self.present(editCancelAlert, animated: true)
  }

  private func confirmCancelCard() {
    logicController.confirmCardCancellation()
  }

  // MARK: - Callbacks

  private func checkoutCompletion(_ result: CheckoutResult) {
    switch result {
    case .success(let token):
      loadingView.startLoadingSpinner()
      logicController.checkoutSuccess(checkoutToken: token)
      navigationController?.popToRootViewController(animated: true)

    case .cancelled(let reason):
      logicController.checkoutCancel(reason: reason)
    }
  }
}
