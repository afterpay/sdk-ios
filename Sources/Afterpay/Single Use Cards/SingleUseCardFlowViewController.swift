//
//  SingleUseCardFlowViewController.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 9/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import UIKit
import WebKit

// swiftlint:disable file_length type_body_length
final class SingleUseCardFlowViewController: UIViewController, UIAdaptivePresentationControllerDelegate {

  enum Screen: Equatable {
    case welcome
    case amount
    case singleUseCard(amount: Money, virtualCard: VirtualCard, vccExpiry: String)
    case checkout(CheckoutWebViewController)
    case info
    case cancel
    case loading
  }

  // View State
  private var currentScreen: Screen = .welcome {
    didSet {
      if #available(iOS 13.0, *) {
        isModalInPresentation = currentScreen == .loading
      }

      updateNavigationBar()
      updatePresentationControllerDelegate()
      reloadView()
    }
  }

  // Payload for consumer cards API request
  private var singleUseCardRequest: SingleUseCardCreateRequest

  private var virtualCard: VirtualCard?

  private let completion: (_ result: SingleUseCardCheckoutResult) -> Void

  private let welcomeView: WelcomeView
  private let enterAmountView: EnterAmountView
  private let singleUseCardView: SingleUseCardView
  private let loadingView: LoadingView
  private let infoViewController: SingleUseCardInfoViewController
  private var infoBarButtonItem: UIBarButtonItem?
  private var checkoutToken: String
  private var singleUseCardToken: String
  private let mode: Mode

  init(
    with singleUseCardRequest: SingleUseCardCreateRequest,
    completion: @escaping (_ result: SingleUseCardCheckoutResult) -> Void,
    mode: Mode,
    aggregatorName: String
  ) {
    let merchantName = singleUseCardRequest.merchant.name

    self.singleUseCardRequest = singleUseCardRequest
    self.completion = completion
    self.checkoutToken = ""
    self.singleUseCardToken = ""
    self.mode = mode

    self.welcomeView = WelcomeView(
      continueAction: #selector(requireAmountAction),
      aggregatorName: aggregatorName
    )
    self.enterAmountView = EnterAmountView(
      continueAction: #selector(triggerCheckoutFlowAction),
      merchantName: merchantName
    )
    self.singleUseCardView = SingleUseCardView(
      merchantName: "\(merchantName) via \(aggregatorName)",
      continueAction: #selector(dismissSingleUseCardFlow),
      editCancelAction: #selector(showEditCancelPage)
    )
    self.loadingView = LoadingView()
    self.infoViewController = SingleUseCardInfoViewController(merchantName: merchantName, aggregator: aggregatorName)

    super.init(nibName: nil, bundle: nil)
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

    setupSubViews()
    setupNavigationBar()
    reloadView()
  }

  private func reloadView() {
    var subview: UIView

    switch currentScreen {
    case .welcome:
      subview = welcomeView
    case .amount:
      loadingView.stopLoadingSpinner()
      enterAmountView.amountField.becomeFirstResponder()
      subview = enterAmountView
    case .singleUseCard(let amount, let virtualCard, let expiry):
      loadingView.stopLoadingSpinner()
      singleUseCardView.updateCardDetails(with: amount, virtualCard: virtualCard, expiry: expiry)
      subview = singleUseCardView
    case .checkout(let viewControllerToPresent):
      loadingView.stopLoadingSpinner()
      navigationController?.show(viewControllerToPresent, sender: self)
      return
    case .info:
      loadingView.stopLoadingSpinner()
      let viewControllerToPresent = infoViewController
      navigationController?.show(viewControllerToPresent, sender: self)
      return
    case .loading:
      loadingView.startLoadingSpinner()
      subview = loadingView
    case .cancel:
      let viewControllerToPresent = CancelCardViewController(cancelAction: confirmCancelCard)
      navigationController?.show(viewControllerToPresent, sender: self)
      return
    }

    view.bringSubviewToFront(subview)
    updateLayout(with: subview)
    updateKeyboard()
  }

  // MARK: - Screen triggered updates

  private func updateKeyboard() {
    switch currentScreen {
    case .amount:
      enterAmountView.becomeFirstResponder()
    default:
      enterAmountView.endEditing(true)
    }
  }

  private func updateNavigationBar() {
    switch currentScreen {
    case .loading, .checkout:
      navigationController?.setNavigationBarHidden(true, animated: true)
    case .singleUseCard:
      navigationController?.setNavigationBarHidden(false, animated: true)
      navigationItem.leftBarButtonItem = nil
    default:
      navigationItem.leftBarButtonItem = infoBarButtonItem
      navigationController?.setNavigationBarHidden(false, animated: true)
    }
  }

  private func setupSubViews() {
    welcomeView.backgroundColor = view.backgroundColor
    enterAmountView.backgroundColor = view.backgroundColor
    singleUseCardView.backgroundColor  = view.backgroundColor
    loadingView.backgroundColor = view.backgroundColor

    welcomeView.translatesAutoresizingMaskIntoConstraints = false
    enterAmountView.translatesAutoresizingMaskIntoConstraints = false
    singleUseCardView.translatesAutoresizingMaskIntoConstraints = false

    loadingView.frame = view.frame

    view.addSubview(welcomeView)
    view.addSubview(enterAmountView)
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

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .stop,
      target: self,
      action: #selector(dismissSingleUseCardFlow)
    )

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

    updateNavigationBar()
  }

  private func updatePresentationControllerDelegate() {
    switch currentScreen {
    case .checkout(let viewControllerToPresent):
      navigationController?.presentationController?.delegate = viewControllerToPresent
    default:
      navigationController?.presentationController?.delegate = self
    }
  }

  private func dismissModalCompletion() {
    guard let virtualCard = virtualCard, case .singleUseCard = currentScreen else {
      return
    }
    completion(.success(virtualCard: virtualCard))
  }

  // MARK: - UIAdaptivePresentationControllerDelegate

  func presentationControllerWillDismiss(_ presentationController: UIPresentationController) {
    dismissModalCompletion()
  }

  // MARK: - Navigation Bar Button Actions
  @objc private func dismissSingleUseCardFlow() {
    dismiss(animated: true) { [weak self] in
      self?.dismissModalCompletion()
    }
  }

  // MARK: - Button Actions

  @objc private func requireAmountAction() {
    enterAmountView.amountField.text = singleUseCardRequest.amount.amount
    currentScreen = .amount
  }

  @objc private func triggerCheckoutFlowAction() {
    let amountValue = enterAmountView.amountField.text ?? "0.00"
    singleUseCardRequest.amount = Money(amount: amountValue, currency: singleUseCardRequest.amount.currency)
    currentScreen = .loading

    callSingleUseCardCreateAPI(payload: singleUseCardRequest)
  }

  @objc private func showInfoPage() {
    currentScreen = .info
  }

  @objc private func showEditCancelPage() {
    let editCardAction = UIAlertAction(title: "Edit Card Amount", style: .default)
    let cancelAction = UIAlertAction(title: "Cancel Single-Use card", style: .destructive) { [weak self] _ in
      self?.currentScreen = .cancel
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
    loadingView.startLoadingSpinner()
    currentScreen = .loading
    callSingleUseCardCancelAPI()
  }

  // MARK: - Callbacks

  private func checkoutCompletion(_ result: CheckoutResult) {
    switch result {
    case .success(let token):
      checkoutToken = token
      currentScreen = .loading
      loadingView.startLoadingSpinner()
      callSingleUseCardConfirmAPI()
      navigationController?.popToRootViewController(animated: true)

    case .cancelled(let reason):
      completion(.failed(reason: .checkoutCancelled(reason: reason)))
      navigationController?.popToRootViewController(animated: true)
      currentScreen = .amount
    }
  }

  // MARK: - API Calls

  private func callSingleUseCardConfirmAPI() {
    let payload = SingleUseCardConfirmRequest(
      consumerCardToken: singleUseCardToken,
      token: checkoutToken,
      aggregator: singleUseCardRequest.aggregator
    )

    APIPlusNetworkService.shared.request(
      endpoint: .singleUseCardConfirm(payload),
      mode: mode
    ) { [weak self] (result: Result<SingleUseCardConfirmResponse, Error>) in
      DispatchQueue.main.async {
        result.fold(
          successTransform: { response in self?.handleConfirmCardSucces(response) },
          errorTransform: { error in self?.dismissAndHandleError(error: error) }
        )
      }
    }
  }

  private func callSingleUseCardCreateAPI(payload: SingleUseCardCreateRequest) {
    APIPlusNetworkService.shared.request(
      endpoint: .singleUseCards(payload),
      mode: mode
    ) { [weak self] (result: Result<SingleUseCardCreateResponse, Error>) in
      DispatchQueue.main.async {
        result.fold(
          successTransform: { response in self?.handleCreateCardSuccess(response) },
          errorTransform: { error in self?.dismissAndHandleError(error: error)}
        )
      }
    }
  }

  // TODO: Handle when cancelling card fails
  private func callSingleUseCardCancelAPI() {
    let payload = SingleUseCardCancelRequest(
      consumerCardToken: self.singleUseCardToken,
      token: checkoutToken,
      aggregator: self.singleUseCardRequest.aggregator
    )

    APIPlusNetworkService.shared.request(
      endpoint: .singleUseCardCancel(payload),
      mode: mode) { [weak self] result in
      result.fold(
        successTransform: { _ in self?.handleCancelCardSuccess() },
        errorTransform: { _ in return }
      )
    }
  }

  // MARK: - API Response handlers

  private func handleConfirmCardSucces(_ response: SingleUseCardConfirmResponse) {
    let virtualCard = response.paymentDetails.virtualCard
    self.virtualCard = virtualCard

    currentScreen = .singleUseCard(
      amount: singleUseCardRequest.amount,
      virtualCard: virtualCard,
      vccExpiry: response.vccExpiry
    )
  }

  private func handleCreateCardSuccess(_ response: SingleUseCardCreateResponse) {
    self.singleUseCardToken = response.consumerCardToken

    let viewControllerToPresent: CheckoutWebViewController = CheckoutWebViewController(
      checkoutUrl: response.redirectCheckoutUrl,
      keepModelOpenOnComplete: true,
      completion: checkoutCompletion(_:)
    )

    currentScreen = .checkout(viewControllerToPresent)
  }

  private func handleCancelCardSuccess() {
    DispatchQueue.main.async {
      self.dismiss(animated: true) { [weak self] in
        self?.completion(.failed(reason: .cardCancelled))
      }
    }
  }

  private func dismissAndHandleError(error: Error) {
    dismiss(animated: true) { [weak self] in
      self?.handleAPICallError(error: error)
    }
  }

  private func handleAPICallError(error: Error) {
    if let apiError = error as? APIPlusError, case .error(let details) = apiError {
      completion(.failed(reason: .apiError(details)))
    } else {
      completion(.failed(reason: .networkError(error)))
    }
  }
}
// swiftlint:enable file_length type_body_length
