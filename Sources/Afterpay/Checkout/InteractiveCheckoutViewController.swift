//
//  InteractiveCheckoutViewController.swift
//  Afterpay
//
//  Created by Adam Campbell on 23/11/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit
import WebKit

// swiftlint:disable:next colon
final class InteractiveCheckoutViewController:
  UIViewController,
  UIAdaptivePresentationControllerDelegate,
  WKNavigationDelegate,
  WKScriptMessageHandler,
  WKUIDelegate
{ // swiftlint:disable:this opening_brace

  // MARK: Callbacks

  private let didCommenceCheckoutClosure: DidCommenceCheckoutClosure?
  private let shippingAddressDidChangeClosure: ShippingAddressDidChangeClosure?
  private let shippingOptionDidChangeClosure: ShippingOptionsDidChangeClosure?
  private let completion: (_ result: CheckoutResult) -> Void

  private var didCommenceCheckout: DidCommenceCheckoutClosure? {
    didCommenceCheckoutClosure ?? getInteractiveCheckoutHandler()?.didCommenceCheckout
  }

  private var shippingAddressDidChange: ShippingAddressDidChangeClosure? {
    shippingAddressDidChangeClosure ?? getInteractiveCheckoutHandler()?.shippingAddressDidChange
  }

  private var shippingOptionDidChange: ShippingOptionsDidChangeClosure? {
    shippingOptionDidChangeClosure ?? getInteractiveCheckoutHandler()?.shippingOptionDidChange
  }

  // MARK: URLs

  private let bootstrapURL: URL = URL(string: "https://afterpay.github.io/sdk-example-server/")!
  private var checkoutURL: URL!

  // MARK: Web Views

  private var loadingWebView: WKWebView!
  private var bootstrapWebView: WKWebView!
  private var checkoutWebView: WKWebView!

  // MARK: Initialization

  init(
    didCommenceCheckout: DidCommenceCheckoutClosure?,
    shippingAddressDidChange: ShippingAddressDidChangeClosure?,
    shippingOptionDidChange: ShippingOptionsDidChangeClosure?,
    completion: @escaping (_ result: CheckoutResult) -> Void
  ) {
    self.didCommenceCheckoutClosure = didCommenceCheckout
    self.shippingAddressDidChangeClosure = shippingAddressDidChange
    self.shippingOptionDidChangeClosure = shippingOptionDidChange
    self.completion = completion

    super.init(nibName: nil, bundle: nil)

    presentationController?.delegate = self

    if #available(iOS 13.0, *) {
      overrideUserInterfaceStyle = .light
    }
  }

  override func loadView() {
    let preferences = WKPreferences()
    preferences.javaScriptEnabled = true
    preferences.javaScriptCanOpenWindowsAutomatically = true

    let userContentController = WKUserContentController()
    userContentController.add(self, name: "iOS")

    let configuration = WKWebViewConfiguration()
    configuration.preferences = preferences
    configuration.userContentController = userContentController

    bootstrapWebView = WKWebView(frame: .zero, configuration: configuration)
    bootstrapWebView.isHidden = true
    bootstrapWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    bootstrapWebView.navigationDelegate = self
    bootstrapWebView.uiDelegate = self

    loadingWebView = WKWebView()
    loadingWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    let view = UIView()
    [bootstrapWebView, loadingWebView].forEach(view.addSubview)
    self.view = view
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

    loadingWebView.loadHTMLString(StaticContent.loadingHTML, baseURL: nil)

    let request = URLRequest(url: bootstrapURL)
    bootstrapWebView.load(request)
  }

  // MARK: UIAdaptivePresentationControllerDelegate

  func presentationControllerShouldDismiss(
    _ presentationController: UIPresentationController
  ) -> Bool {
    presentCancelConfirmation()

    return false
  }

  // MARK: Actions

  @objc private func presentCancelConfirmation() {
    let actionSheet = Alerts.areYouSureYouWantToCancel {
      self.dismiss(animated: true) { self.completion(.cancelled(reason: .userInitiated)) }
    }

    present(actionSheet, animated: true, completion: nil)
  }

  // MARK: WKNavigationDelegate

  private let externalLinkPathComponents = ["privacy-policy", "terms-of-service"]

  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    guard
      let url = navigationAction.request.url,
      externalLinkPathComponents.contains(url.lastPathComponent)
    else {
      return decisionHandler(.allow)
    }

    decisionHandler(.cancel)
    UIApplication.shared.open(url)
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    if webView == checkoutWebView {
      checkoutWebView.isHidden = false
      loadingWebView.removeFromSuperview()
      loadingWebView = nil
    } else if webView == bootstrapWebView {
      commenceCheckout()
    }
  }

  private func commenceCheckout() {
    assert(
      didCommenceCheckout != nil,
      "For checkout to function you must set `didCommenceCheckout` via either "
        + "`Afterpay.presentInteractiveCheckoutModally` or `Afterpay.setInteractiveCheckoutHandler`"
    )

    let urlAppendingIsWindowed = { (url: URL) -> URL in
      var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
      let isWindowed = URLQueryItem(name: "isWindowed", value: "true")
      let queryItems = urlComponents?.queryItems ?? []
      urlComponents?.queryItems = queryItems + [isWindowed]
      return urlComponents?.url ?? url
    }

    let handleCheckoutURL = { [weak self] (url: URL) in
      let updatedURL = urlAppendingIsWindowed(url)
      self?.checkoutURL = updatedURL
      let javaScript = "openAfterpay('\(updatedURL.absoluteString)');"
      DispatchQueue.main.async { self?.bootstrapWebView.evaluateJavaScript(javaScript) }
    }

    let dismiss = { [weak self] result in
      self?.dismiss(animated: true) { self?.completion(result) }
    }

    let handleError = { [weak self] (error: Error) in
      let alert = Alerts.failedToLoad(
        retry: { self?.commenceCheckout() },
        cancel: { dismiss(.cancelled(reason: .networkError(error))) }
      )

      self?.present(alert, animated: true, completion: nil)
    }

    let isValid = { (url: URL) in url.host.map(CheckoutHost.validSet.contains) ?? false }

    didCommenceCheckout? { result in
      switch result {
      case (.success(let url)):
        isValid(url) ? handleCheckoutURL(url) : dismiss(.cancelled(reason: .invalidURL(url)))
      case (.failure(let error)):
        handleError(error)
      }
    }
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
    checkoutWebView = WKWebView(frame: view.bounds, configuration: configuration)
    checkoutWebView.isHidden = true
    checkoutWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    checkoutWebView.allowsLinkPreview = false
    checkoutWebView.navigationDelegate = self
    view.addSubview(checkoutWebView)

    return checkoutWebView
  }

  // MARK: WKScriptMessageHandler

  typealias Completion = InteractiveCheckoutCompletion
  typealias Message = InteractiveCheckoutMessage

  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  func userContentController(
    _ userContentController: WKUserContentController,
    didReceive message: WKScriptMessage
  ) {
    let jsonData = (message.body as? String)?.data(using: .utf8)
    let message = jsonData.flatMap { try? decoder.decode(Message.self, from: $0) }
    let completion = jsonData.flatMap { try? decoder.decode(Completion.self, from: $0) }

    let postMessage = { [encoder, checkoutURL, bootstrapWebView] (message: Message) in
      let data = try? encoder.encode(message)
      let json = data.flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
      let targetURL = URL(string: "/", relativeTo: checkoutURL)?.absoluteString ?? "*"
      let javaScript = "postCheckoutMessage(JSON.parse('\(json)'), '\(targetURL)');"
      DispatchQueue.main.async { bootstrapWebView?.evaluateJavaScript(javaScript) }
    }

    switch (message, message?.payload, completion) {
    case (let message?, .address(let address), _):
      shippingAddressDidChange?(address) { options in
        postMessage(.init(requestId: message.requestId, payload: .shippingOptions(options)))
      }

    case(_, .shippingOption(let shippingOption), _):
      shippingOptionDidChange?(shippingOption)

    case (_, _, .success(let token)):
      dismiss(animated: true) { self.completion(.success(token: token)) }

    case (_, _, .cancelled):
      dismiss(animated: true) { self.completion(.cancelled(reason: .userInitiated)) }

    default:
      break
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
