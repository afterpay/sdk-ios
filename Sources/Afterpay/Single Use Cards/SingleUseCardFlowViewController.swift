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
  private let singleUseCardViewController: VirtualCardDisplayViewController
  private let loadingViewController: LoadingViewController
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
    self.singleUseCardViewController = VirtualCardDisplayViewController(
      merchantName: "\(logicController.merchantName) via \(logicController.aggregatorName)"
    )

    self.loadingViewController = LoadingViewController()
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

    singleUseCardViewController.configureButtons(
      continueAction: dismissSingleUseCardFlow,
      editCancelAction: showEditCancelActionSheet
    )
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overrides
  override func viewDidLoad() {
    super.viewDidLoad()

    if #available(iOS 13.0, *) {
      overrideUserInterfaceStyle = .light
    }

    view.backgroundColor = .white

    navigationController?.presentationController?.delegate = self

    logicController.navigateToCurrentScreen()

    setupNavigationBar()
  }

  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }

  // MARK: - Setups
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

  // MARK: - Updates
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
      singleUseCardViewController.navigationItem.hidesBackButton = true
      singleUseCardViewController.navigationItem.rightBarButtonItem = closeBarButtonItem
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

  // MARK: - Handlers
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
      // TODO: Show error in enter amount screen instead
      completion(.failed(reason: .checkoutCancelled(reason: reason)))
    case .navigate(let origin, let destination):
      if #available(iOS 13.0, *) {
        isModalInPresentation = destination == .loading
      }
      navigateScreen(from: origin, to: destination)
      updateNavigationBar(screen: destination)
      updatePresentationControllerDelegate(screen: destination)
    }
  }

  // MARK: - Screen navigation
  private func navigateScreen(from origin: Screen, to destination: Screen) {
    switch destination {
    case .initialAmount(let value):
      enterAmountViewController.setAmount(value: value)
      if navigationController?.contains(enterAmountViewController) ?? false {
        navigationController?.popToViewController(enterAmountViewController, animated: true)
      } else {
        navigationController?.setViewControllers([self, enterAmountViewController], animated: false)
      }
    case .editAmount(let value):
      enterAmountViewController.setAmount(value: value)
      if navigationController?.contains(enterAmountViewController) ?? false {
        navigationController?.popToViewController(enterAmountViewController, animated: true)
      } else {
        navigationController?.setViewControllers(
          [self, singleUseCardViewController, enterAmountViewController],
          animated: true
        )
      }
    case .singleUseCard:
      guard
        let card = logicController.singleUseCard.virtualCard,
        let expiry = logicController.singleUseCard.expiry
      else {
        return
      }
      singleUseCardViewController.updateCardDetails(with: logicController.amount, virtualCard: card, expiry: expiry)
      navigationController?.setViewControllers([self, singleUseCardViewController], animated: true)

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
      navigationController?.show(loadingViewController, sender: self)
    case .cancel:
      let viewControllerToPresent = CancelCardViewController(
        cancelAction: confirmCancelCard,
        editCardAction: editAmountCard
      )
      singleUseCardViewController.navigationController?.show(viewControllerToPresent, sender: self)
    }
  }

  // MARK: - UIAdaptivePresentationControllerDelegate

  func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
    logicController.dismissModal()
  }

  // MARK: - Button Actions
  @objc private func showInfoPage() {
    logicController.showInfoPage()
  }

  @objc private func dismissSingleUseCardFlow() {
    dismiss(animated: true) { [weak self] in
      self?.logicController.dismissModal()
    }
  }

  private func triggerCheckoutFlowAction() {
    let amountValue = enterAmountViewController.getAmountValue() ?? "0.00"
    logicController.loadCheckout(amountValue: amountValue)
  }

  private func triggerCheckoutFlowActionfForEdit() {
    let amountValue = enterAmountViewController.getAmountValue() ?? "0.00"
    logicController.loadCheckout(amountValue: amountValue)
  }

  private func showEditCancelActionSheet() {
    let editCardAction = UIAlertAction(title: "Edit Card Amount", style: .default) { [weak self] _ in
      self?.editAmountCard()
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

  private func editAmountCard() {
    logicController.showEditCardScreen()
  }

  // MARK: - Callbacks

  private func checkoutCompletion(_ result: CheckoutResult) {
    switch result {
    case .success:
      logicController.checkoutSuccess()
      navigationController?.popToRootViewController(animated: true)

    case .cancelled(let reason):
      logicController.checkoutCancel(reason: reason)
    }
  }
}
