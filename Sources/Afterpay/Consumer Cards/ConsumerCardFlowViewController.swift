//
//  ConsumerCardFlowViewController.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 9/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import UIKit
import WebKit

final class ConsumerCardFlowViewController: UIViewController {

  enum Screen: Equatable {
    case welcome
    case amount
    case consumerCard(cardNumber: String)
    case checkout(CheckoutWebViewController)
    case loading
  }

  // View State
  private var currentScreen: Screen = .welcome {
    didSet {
      if #available(iOS 13.0, *) {
        isModalInPresentation = currentScreen == .loading
      }

      updateNavigationBar()
      reloadView()
    }
  }

  // Payload for consumer cards API request
  private var consumerCardRequest: ConsumerCardRequest

  private let completion: (_ result: ConsumerCardCheckoutResult) -> Void

  private let welcomeView: WelcomeView
  private let enterAmountView: EnterAmountView
  private let consumerCardView: ConsumerCardView
  private let loadingView: LoadingView

  private var consumerCardToken: String
  private var token: String
  private var authToken: String

  init(
    with payload: ConsumerCardRequest,
    completion: @escaping (_ result: ConsumerCardCheckoutResult) -> Void
  ) {
    // Validate parameters value

    self.consumerCardRequest = payload

    // initiate views
    welcomeView = WelcomeView(continueAction: #selector(requireAmountAction))
    enterAmountView = EnterAmountView(continueAction: #selector(triggerCheckoutFlowAction))
    consumerCardView = ConsumerCardView(cardNumber: "")
    loadingView = LoadingView()

    self.completion = completion

    self.consumerCardToken = ""
    self.token = ""
    self.authToken = ""

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white

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
      subview = enterAmountView
    case .consumerCard(let cardNumber):
      loadingView.stopLoadingSpinner()
      consumerCardView.updateCardNumber(with: cardNumber)
      subview = consumerCardView
    case .checkout(let viewControllerToPresent):
      loadingView.stopLoadingSpinner()
      navigationController?.show(viewControllerToPresent, sender: self)
      return
    case .loading:
      loadingView.startLoadingSpinner()
      subview = loadingView
    }

    view.bringSubviewToFront(subview)
    updateLayout(with: subview)
  }

  private func updateNavigationBar() {
    switch currentScreen {
    case .loading, .checkout:
      navigationController?.setNavigationBarHidden(true, animated: true)
    case .consumerCard:
      navigationController?.setNavigationBarHidden(false, animated: true)
      navigationItem.leftBarButtonItem = nil
    default:
      navigationController?.setNavigationBarHidden(false, animated: true)
    }
  }

  private func setupSubViews() {
    welcomeView.backgroundColor = view.backgroundColor
    enterAmountView.backgroundColor = view.backgroundColor
    consumerCardView.backgroundColor  = view.backgroundColor
    loadingView.backgroundColor = view.backgroundColor

    welcomeView.translatesAutoresizingMaskIntoConstraints = false
    enterAmountView.translatesAutoresizingMaskIntoConstraints = false
    consumerCardView.translatesAutoresizingMaskIntoConstraints = false

    loadingView.frame = view.frame

    view.addSubview(welcomeView)
    view.addSubview(enterAmountView)
    view.addSubview(consumerCardView)
    view.addSubview(loadingView)
  }

  private func updateLayout(with subview: UIView) {
    NSLayoutConstraint.activate([
      subview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      subview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      subview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      subview.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }

  private func setupNavigationBar() {
    navigationController?.navigationBar.barStyle = .black
    navigationController?.navigationBar.isTranslucent = false
    navigationController?.navigationBar.barTintColor = view.backgroundColor
    navigationController?.navigationBar.tintColor = .black

    navigationItem.titleView = LogoView()

    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissConsumerCardFlow))
    navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Info", style: .plain, target: self, action: nil)
  }

  // MARK: - Navigation Bar Button Actions
  @objc private func dismissConsumerCardFlow() {
    switch currentScreen {
    case .consumerCard(let cardNumber):
      dismiss(animated: true) { [weak self] in

        // Temporarily initiate a virtual card
        let virtualCard = VirtualCard(cardType: "VISA", cardNumber: cardNumber, cvc: "123", expiry: "02/02/23")
        self?.completion(.success(virtualCard: virtualCard))
      }
    default:
      dismiss(animated: true, completion: nil)
    }
  }

  // MARK: - Button Actions

  @objc private func requireAmountAction() {
    enterAmountView.amountField.text = consumerCardRequest.amount.amount
    currentScreen = .amount
  }

  @objc private func triggerCheckoutFlowAction() {
    let amountValue = enterAmountView.amountField.text ?? "0.00"
    consumerCardRequest.amount = Money(amount: amountValue, currency: consumerCardRequest.amount.currency)
    currentScreen = .loading

    callConsumerCardAPI(payload: consumerCardRequest)
  }

  // MARK: - Callbacks
  private func cookiesChangedCallback(cookieStore: WKHTTPCookieStore) {
    cookieStore.getAllCookies { [weak self] cookies in
      let authCookie = cookies.first {
        let portalApiDomain = "portalapi.us-sandbox.afterpay.com"
        let authCookieName = "pl_status"
        return ($0.name == authCookieName && $0.domain == portalApiDomain)
      }
      guard let cookie = authCookie else {
        return
      }
      if !cookie.value.isEmpty {
        self?.authToken = cookie.value
      }
    }
  }

  private func checkoutCompletion(_ result: CheckoutResult) {
    switch result {
    case .success(let token):
      self.callConsumerCardConfirmAPI(checkoutToken: token)

    case .cancelled(let reason):
      completion(.failed(reason: .checkoutCancelled(reason: reason)))
    }
  }

  // MARK: - API Calls

  private func callConsumerCardConfirmAPI(checkoutToken: String) {
    let payload = ConsumerCardConfirmRequest(
      consumerCardToken: self.consumerCardToken,
      token: checkoutToken,
      requestId: "",
      xAuthToken: authToken,
      aggregator: "deadbeef"
    )

    currentScreen = .loading
    loadingView.startLoadingSpinner()

    NetworkService.shared.request(endpoint: .consumerCardConfirm(payload)) { [unowned self] (result: Result<ConsumerCardConfirmResponse, Error>) in
      switch result {
      case .success(let response):
        DispatchQueue.main.async {
          self.currentScreen = .consumerCard(cardNumber: response.paymentDetails.virtualCard.cardNumber)
        }
      case .failure(let error):
        completion(.failed(reason: .networkError(error)))
      }
    }

    self.navigationController?.popToRootViewController(animated: true)
    self.navigationController?.presentationController?.delegate = .none
  }

  private func callConsumerCardAPI(payload: ConsumerCardRequest) {
    NetworkService.shared.request(endpoint: .consumerCards(payload)) { [unowned self] (result: Result<ConsumerCardResponse, Error>) in
      switch result {
      case .success(let response):
        self.consumerCardToken = response.consumerCardToken

        DispatchQueue.main.async {
          let viewControllerToPresent: CheckoutWebViewController = CheckoutWebViewController(
            checkoutUrl: response.redirectCheckoutUrl,
            consumerCardFlow: true,
            cookieChangeCallback: cookiesChangedCallback(cookieStore:),
            completion: checkoutCompletion(_:)
          )

          currentScreen = .checkout(viewControllerToPresent)
        }
      case .failure(let error):
        completion(.failed(reason: .networkError(error)))
      }
    }
  }
}
