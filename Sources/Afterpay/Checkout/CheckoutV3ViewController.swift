//
//  CheckoutV3ViewController.swift
//  Afterpay
//
//  Created by Chris Kolbu on 12/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import UIKit
import WebKit

// swiftlint:disable:next colon type_body_length
final class CheckoutV3ViewController:
  UIViewController,
  UIAdaptivePresentationControllerDelegate,
  WKNavigationDelegate
{ // swiftlint:disable:this opening_brace

  private let checkout: CheckoutV3.Request
  private let configuration: CheckoutV3Configuration
  private let requestHandler: URLRequestHandler
  private var currentTask: URLSessionDataTask?
  private let completion: (_ result: CheckoutV3Result) -> Void

  private var token: Token?
  private var singleUseCardToken: Token?
  private var ppaConfirmToken: Token?

  private var webView: WKWebView { view as! WKWebView }

  // MARK: Initialization

  init(
    checkout: CheckoutV3.Request,
    configuration: CheckoutV3Configuration,
    requestHandler: @escaping URLRequestHandler,
    completion: @escaping (_ result: CheckoutV3Result) -> Void
  ) {
    self.checkout = checkout
    self.configuration = configuration
    self.requestHandler = requestHandler
    self.completion = completion

    super.init(nibName: nil, bundle: nil)
    self.title = "Afterpay"
  }

  override func loadView() {
    let config = WKWebViewConfiguration()
    config.applicationNameForUserAgent = WKWebViewConfiguration.appNameForUserAgent

    view = WKWebView(frame: .zero, configuration: config)
  }

  // MARK: - View lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.rightBarButtonItem = UIBarButtonItem(
      title: "Cancel",
      style: .plain,
      target: self,
      action: #selector(presentCancelConfirmation)
    )

    if #available(iOS 13.0, *) {
      overrideUserInterfaceStyle = .light
      isModalInPresentation = true
    }

    navigationController?.presentationController?.delegate = self

    webView.allowsLinkPreview = false
    webView.navigationDelegate = self
    webView.scrollView.bounces = false
    webView.loadHTMLString(StaticContent.loadingHTML, baseURL: nil)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    guard
      let host = URLComponents(url: configuration.v3CheckoutUrl, resolvingAgainstBaseURL: false)?.host,
      CheckoutHost.validSet.contains(host)
    else {
      return dismiss(animated: true) { [completion, url = configuration.v3CheckoutUrl] in
        completion(.cancelled(reason: .invalidURL(url)))
      }
    }

    performCheckoutRequest { redirectUrl in
      self.webView.load(ApiV3.request(from: redirectUrl))
    }
  }

  // MARK: UIAdaptivePresentationControllerDelegate

  func presentationControllerDidAttemptToDismiss(
    _ presentationController: UIPresentationController
  ) {
    presentCancelConfirmation()
  }

  // MARK: Actions

  override func accessibilityPerformEscape() -> Bool {
    presentCancelConfirmation()
    return true
  }

  @objc private func presentCancelConfirmation() {
    let actionSheet = Alerts.areYouSureYouWantToCancel {
      self.currentTask?.cancel()
      self.dismiss(animated: true) { self.completion(.cancelled(reason: .userInitiated)) }
    }

    present(actionSheet, animated: true, completion: nil)
  }

  // MARK: WKNavigationDelegate

  private enum Completion {
    case success(token: String, ppaConfirmToken: String)
    case cancelled

    init?(url: URL) {
      let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
      let statusItem = queryItems?.first { $0.name == "status" }
      let ppaConfirmToken = queryItems?.first { $0.name == "ppaConfirmToken" }
      let orderTokenItem = queryItems?.first { $0.name == "orderToken" }

      switch (statusItem?.value, orderTokenItem?.value, ppaConfirmToken?.value) {
      case ("SUCCESS", let token?, let ppaConfirmToken?):
        self = .success(token: token, ppaConfirmToken: ppaConfirmToken)
      case ("CANCELLED", _, _):
        self = .cancelled
      default:
        return nil
      }
    }
  }

  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    guard let url = navigationAction.request.url else {
      return decisionHandler(.allow)
    }

    let shouldOpenExternally = navigationAction.targetFrame == nil

    switch (shouldOpenExternally, Completion(url: url)) {
    case (true, _):
      decisionHandler(.cancel)
      UIApplication.shared.open(url)

    case (false, .success(_, let ppaConfirmToken)):
      decisionHandler(.cancel)
      self.ppaConfirmToken = ppaConfirmToken
      self.performConfirmationRequest()

    case (false, .cancelled):
      decisionHandler(.cancel)
      dismiss(animated: true) { self.completion(.cancelled(reason: .userInitiated)) }

    case (false, nil):
      decisionHandler(.allow)
    }
  }

  func webView(
    _ webView: WKWebView,
    didFailProvisionalNavigation navigation: WKNavigation!,
    withError error: Error
  ) {
    let alert = Alerts.failedToLoad(
      retry: { [url = configuration.environment.checkoutBootstrapURL] in
        webView.load(URLRequest(url: url))
      },
      cancel: {
        self.dismiss(animated: true) {
          self.completion(.cancelled(reason: .networkError(error)))
        }
      }
    )

    present(alert, animated: true, completion: nil)
  }

  func webView(
    _ webView: WKWebView,
    didReceive challenge: URLAuthenticationChallenge,
    completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
  ) {
    let handled = authenticationChallengeHandler(challenge, completionHandler)

    if handled == false {
      completionHandler(.performDefaultHandling, nil)
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Requests

  private func performCheckoutRequest(_ completion: @escaping (URL) -> Void) {
    let request = self.createCheckoutRequest()
    self.currentTask = ApiV3.request(self.requestHandler, request, type: CheckoutV3.Response.self) { result in
      switch result {
      case .success(let response):
        self.token = response.token
        self.singleUseCardToken = response.singleUseCardToken
        completion(response.redirectCheckoutUrl)
      case .failure(let error):
        self.dismiss(animated: true) { self.completion(.cancelled(reason: .networkError(error))) }
      }
    }

    self.currentTask?.resume()
  }

  private func performConfirmationRequest() {
    guard let request = self.createConfirmationRequest() else {
      return
    }

    self.currentTask = ApiV3.request(self.requestHandler, request, type: ConfirmationV3.Response.self) { result in
      switch result {
      case .success(let response):
        self.dismiss(animated: true) {
          self.handleConfirmationResponse(response)
        }
      case .failure(let error):
        self.dismiss(animated: true) { self.completion(.cancelled(reason: .networkError(error))) }
      }
    }
    self.currentTask?.resume()
  }

  private func handleConfirmationResponse(_ response: ConfirmationV3.Response) {
    guard let token = self.token else {
      return
    }
    let cancellationRequest = self.createCancellationRequest()
    let updateRequest = self.createMerchantReferenceUpdateRequest()

    let result = CheckoutV3.ResultData(
      cancellation: { [cancellationRequest, requestHandler] cancellationCompletion in
        let task = ApiV3.request(
          requestHandler,
          cancellationRequest,
          completion: cancellationCompletion)
        task.resume()
      },
      merchantReferenceUpdate: { [updateRequest, requestHandler] merchantReference, updateCompletion in
        var request = updateRequest
        // Serialize the merchant reference now that it is known
        request.httpBody = try? JSONEncoder().encode(
          CheckoutV3.MerchantReferenceUpdate(
            authToken: response.authToken,
            token: token,
            merchantReference: merchantReference
          )
        )

        let task = ApiV3.request(requestHandler, request, completion: updateCompletion)
        task.resume()
      },
      cardValidUntil: response.cardValidUntil,
      cardDetails: response.paymentDetails.virtualCard
    )

    self.completion(.success(data: result))
  }

  private func createMerchantReferenceUpdateRequest() -> URLRequest {
    var request = ApiV3.request(from: configuration.v3CheckoutUrl)
    request.httpMethod = "PUT"
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    return request
  }

  private func createCancellationRequest() -> URLRequest {
    guard
      let token = self.token,
      let singleUseCardToken = self.singleUseCardToken,
      let ppaConfirmToken = self.ppaConfirmToken,
      let data = try? JSONEncoder().encode(CancellationV3.Request(
        token: token,
        ppaConfirmToken: ppaConfirmToken,
        singleUseCardToken: singleUseCardToken
      ))
    else {
      fatalError("`token` or `singleUseToken` was nil")
    }
    var request = ApiV3.request(from: self.configuration.v3CheckoutCancellationUrl)
    request.httpMethod = "POST"
    request.httpBody = data
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    return request
  }

  private func createCheckoutRequest() -> URLRequest {
    let data = try! JSONEncoder().encode(self.checkout) // swiftlint:disable:this force_try

    var request = ApiV3.request(from: configuration.v3CheckoutUrl)
    request.httpMethod = "POST"
    request.httpBody = data
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    return request
  }

  private func createConfirmationRequest() -> URLRequest? {
    guard
      let token = self.token,
      let singleUseCardToken = self.singleUseCardToken,
      let ppaConfirmToken = self.ppaConfirmToken
    else {
      return nil
    }

    let confirmation = ConfirmationV3.Request(
      token: token,
      singleUseCardToken:
      singleUseCardToken,
      ppaConfirmToken: ppaConfirmToken
    )

    guard let data = try? JSONEncoder().encode(confirmation) else {
      return nil
    }

    var request = ApiV3.request(from: configuration.v3CheckoutConfirmationUrl)
    request.httpMethod = "POST"
    request.httpBody = data
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    return request
  }

}
