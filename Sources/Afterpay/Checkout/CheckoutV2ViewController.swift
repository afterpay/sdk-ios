//
//  CheckoutV2ViewController.swift
//  Afterpay
//
//  Created by Adam Campbell on 23/11/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import os.log
import UIKit
import WebKit

// swiftlint:disable:next colon
final class CheckoutV2ViewController:
  UIViewController,
  UIAdaptivePresentationControllerDelegate,
  WKNavigationDelegate,
  WKScriptMessageHandler,
  WKUIDelegate
{ // swiftlint:disable:this opening_brace

  private let configuration: Configuration
  private let options: CheckoutV2Options
  private var token: Token?

  // MARK: Callbacks

  private let didCommenceCheckoutClosure: DidCommenceCheckoutClosure?
  private let shippingAddressDidChangeClosure: ShippingAddressDidChangeClosure?
  private let shippingOptionDidChangeClosure: ShippingOptionsDidChangeClosure?
  private let completion: (_ result: CheckoutResult) -> Void

  private var didCommenceCheckout: DidCommenceCheckoutClosure? {
    didCommenceCheckoutClosure ?? getCheckoutV2Handler()?.didCommenceCheckout
  }

  private var shippingAddressDidChange: ShippingAddressDidChangeClosure? {
    shippingAddressDidChangeClosure ?? getCheckoutV2Handler()?.shippingAddressDidChange
  }

  private var shippingOptionDidChange: ShippingOptionsDidChangeClosure? {
    shippingOptionDidChangeClosure ?? getCheckoutV2Handler()?.shippingOptionDidChange
  }

  // MARK: URLs

  private var bootstrapURL: URL { configuration.environment.checkoutBootstrapURL }

  // MARK: Web Views

  private var loadingWebView: WKWebView?
  private var bootstrapWebView: WKWebView!
  private var checkoutWebView: WKWebView?

  // MARK: Initialization

  init(
    configuration: Configuration,
    options: CheckoutV2Options,
    didCommenceCheckout: DidCommenceCheckoutClosure?,
    shippingAddressDidChange: ShippingAddressDidChangeClosure?,
    shippingOptionDidChange: ShippingOptionsDidChangeClosure?,
    completion: @escaping (_ result: CheckoutResult) -> Void
  ) {
    self.configuration = configuration
    self.options = options
    self.didCommenceCheckoutClosure = didCommenceCheckout
    self.shippingAddressDidChangeClosure = shippingAddressDidChange
    self.shippingOptionDidChangeClosure = shippingOptionDidChange
    self.completion = completion

    super.init(nibName: nil, bundle: nil)

    presentationController?.delegate = self

    if #available(iOS 13.0, *) {
      isModalInPresentation = true
      overrideUserInterfaceStyle = .light
    }
  }

  override func loadView() {
    let preferences = WKPreferences()
    preferences.javaScriptEnabled = true
    preferences.javaScriptCanOpenWindowsAutomatically = true

    let userContentController = WKUserContentController()
    userContentController.add(self, name: "iOS")

    let processPool = WKProcessPool()

    let bootstrapConfiguration = WKWebViewConfiguration()
    bootstrapConfiguration.processPool = processPool
    bootstrapConfiguration.preferences = preferences
    bootstrapConfiguration.userContentController = userContentController

    bootstrapWebView = WKWebView(frame: .zero, configuration: bootstrapConfiguration)
    bootstrapWebView.isHidden = true
    bootstrapWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    bootstrapWebView.navigationDelegate = self
    bootstrapWebView.uiDelegate = self

    let loadingConfiguration = WKWebViewConfiguration()
    loadingConfiguration.processPool = processPool

    let loadingWebView = WKWebView(frame: .zero, configuration: loadingConfiguration)
    loadingWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    self.loadingWebView = loadingWebView

    let view = UIView()
    [bootstrapWebView, loadingWebView].forEach(view.addSubview)
    self.view = view
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    bootstrapWebView.configuration.userContentController.removeScriptMessageHandler(forName: "iOS")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if #available(iOS 13.0, *) {
      overrideUserInterfaceStyle = .light
    } else {
      navigationItem.rightBarButtonItem = UIBarButtonItem(
        title: "Cancel",
        style: .plain,
        target: self,
        action: #selector(presentCancelConfirmation)
      )
    }

    loadingWebView?.loadHTMLString(StaticContent.loadingHTML, baseURL: nil)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    let webView: WKWebView = bootstrapWebView

    webView.removeCache(
      for: configuration.environment.bootstrapCacheDisplayName
    ) {
      [bootstrapURL] in webView.load(URLRequest(url: bootstrapURL))
    }
  }

  // MARK: UIAdaptivePresentationControllerDelegate

  func presentationControllerDidAttemptToDismiss(
    _ presentationController: UIPresentationController
  ) {
    presentCancelConfirmation()
  }

  // MARK: Actions

  @objc private func presentCancelConfirmation() {
    let actionSheet = Alerts.areYouSureYouWantToCancel {
      self.dismiss(animated: true) { self.completion(.cancelled(reason: .userInitiated)) }
    }

    present(actionSheet, animated: true, completion: nil)
  }

  // MARK: WKNavigationDelegate

  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    guard let url = navigationAction.request.url, navigationAction.targetFrame == nil else {
      return decisionHandler(.allow)
    }

    decisionHandler(.cancel)
    UIApplication.shared.open(url)
  }

  func webView(
    _ webView: WKWebView,
    didFailProvisionalNavigation navigation: WKNavigation!,
    withError error: Error
  ) {
    handleError(webView: webView, error: error)
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    if webView == checkoutWebView {
      checkoutWebView?.isHidden = false
      loadingWebView?.removeFromSuperview()
      loadingWebView = nil
    } else if webView == bootstrapWebView {
      commenceCheckout()
    }
  }

  private func commenceCheckout() {
    guard let didCommenceCheckout = didCommenceCheckout else {
      return assertionFailure(
        "For checkout to function you must set `didCommenceCheckout` via either "
          + "`Afterpay.presentCheckoutV2Modally` or `Afterpay.setCheckoutV2Handler`"
      )
    }

    didCommenceCheckout { [weak self] result in
      DispatchQueue.main.async {
        switch result {
        case (.success(let token)):
          self?.handleToken(token: token)
        case (.failure(let error)):
          self?.handleError(webView: nil, error: error)
        }
      }
    }
  }

  private func handleToken(token: Token) {
    let checkout = CheckoutV2(token: token, configuration: configuration, options: options)
    // swiftlint:disable:next force_try
    let json = String(data: try! encoder.encode(checkout), encoding: .utf8)!
    let javaScript = "openCheckout('\(json)');"
    bootstrapWebView.evaluateJavaScript(javaScript)
  }

  private func handleError(webView: WKWebView?, error: Error) {
    let dismiss = {
      self.dismiss(animated: true) {
        self.completion(.cancelled(reason: .networkError(error)))
      }
    }

    let reload = {
      switch webView {
      case self.bootstrapWebView:
        self.bootstrapWebView.load(URLRequest(url: self.bootstrapURL))

      case self.checkoutWebView where self.token != nil:
        self.handleToken(token: self.token!)

      case self.checkoutWebView, nil:
        self.commenceCheckout()

      default:
        dismiss()
      }
    }

    let alert = Alerts.failedToLoad(retry: reload, cancel: dismiss)
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

  // MARK: WKUIDelegate

  func webView(
    _ webView: WKWebView,
    createWebViewWith configuration: WKWebViewConfiguration,
    for navigationAction: WKNavigationAction,
    windowFeatures: WKWindowFeatures
  ) -> WKWebView? {
    let checkoutWebView = WKWebView(frame: view.bounds, configuration: configuration)
    checkoutWebView.isHidden = true
    checkoutWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    checkoutWebView.allowsLinkPreview = false
    checkoutWebView.scrollView.bounces = false
    checkoutWebView.navigationDelegate = self
    view.addSubview(checkoutWebView)

    self.checkoutWebView = checkoutWebView

    return checkoutWebView
  }

  // MARK: WKScriptMessageHandler

  typealias Completion = CheckoutV2Completion
  typealias Message = CheckoutV2Message

  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  func userContentController(
    _ userContentController: WKUserContentController,
    didReceive message: WKScriptMessage
  ) {
    let jsonData = (message.body as? String)?.data(using: .utf8)
    let message = jsonData.flatMap { try? decoder.decode(Message.self, from: $0) }
    let completion = jsonData.flatMap { try? decoder.decode(Completion.self, from: $0) }

    let evaluateJavascript = { [bootstrapWebView] (javaScript: String) in
      DispatchQueue.main.async { bootstrapWebView?.evaluateJavaScript(javaScript) }
    }

    let postMessage = { [encoder] (message: Message) in
      Result { String(data: try encoder.encode(message), encoding: .utf8) }
        .fold(successTransform: { $0 }, errorTransform: { _ in nil })
        .map { evaluateJavascript("postMessageToCheckout('\($0)');") }
    }

    if let message = message, let payload = message.payload {
      switch payload {
      case .address(let address):
        shippingAddressDidChange?(address) { shippingOptions in
          let requestId = message.requestId
          let responseMessage = shippingOptions.fold(
            successTransform: { Message(requestId: requestId, payload: .shippingOptions($0)) },
            errorTransform: { Message(requestId: requestId, payload: .errorMessage($0.rawValue)) }
          )
          postMessage(responseMessage)
        }
      case .errorMessage(let errorMessage):
        // Error messages raised in the webview are logged when in Debug for ease of debugging
        os_log("%@", log: .checkout, type: .debug, errorMessage)
      case .shippingOption(let shippingOption):
        shippingOptionDidChange?(shippingOption)
      case .shippingOptions:
        break
      }
    } else if let completion = completion {
      switch completion {
      case .success(let token):
        dismiss(animated: true) { self.completion(.success(token: token)) }
      case .cancelled:
        dismiss(animated: true) { self.completion(.cancelled(reason: .userInitiated)) }
      }
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
