//
//  ExpressCheckoutViewController.swift
//  Afterpay
//
//  Created by Adam Campbell on 23/11/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit
import WebKit

// swiftlint:disable:next colon
final class ExpressCheckoutViewController:
  UIViewController,
  UIAdaptivePresentationControllerDelegate,
  WKNavigationDelegate,
  WKScriptMessageHandler,
  WKUIDelegate
{ // swiftlint:disable:this opening_brace

  private static let bundle = Bundle(for: ExpressCheckoutViewController.self)

  private var checkoutURL: URL!
  private let completion: (_ result: CheckoutResult) -> Void

  private let bootstrapURL: URL = URL(string: "https://afterpay.github.io/sdk-example-server/")!

  private var originWebView: WKWebView!
  private var checkoutWebView: WKWebView!

  // MARK: Initialization

  init(
    checkoutURL: URL?,
    completion: @escaping (_ result: CheckoutResult
  ) -> Void) {

    if let url = checkoutURL {
      var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
      let isWindowed = URLQueryItem(name: "isWindowed", value: "true")
      let queryItems = urlComponents?.queryItems ?? []
      urlComponents?.queryItems = queryItems + [isWindowed]

      self.checkoutURL = urlComponents?.url
    }

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
    userContentController.add(self, name: "nativeApp")

    let configuration = WKWebViewConfiguration()
    configuration.preferences = preferences
    configuration.userContentController = userContentController

    originWebView = WKWebView(frame: .zero, configuration: configuration)
    originWebView.translatesAutoresizingMaskIntoConstraints = false
    originWebView.navigationDelegate = self
    originWebView.uiDelegate = self

    let view = UIView()

    view.addSubview(originWebView)

    NSLayoutConstraint.activate([
      originWebView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      originWebView.topAnchor.constraint(equalTo: view.topAnchor),
      originWebView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      originWebView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    self.view = view
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let request = URLRequest(url: bootstrapURL)
    originWebView.load(request)
  }

  // MARK: UIAdaptivePresentationControllerDelegate

  func presentationControllerShouldDismiss(
    _ presentationController: UIPresentationController
  ) -> Bool {
    return false
  }

  // MARK: WKNavigationDelegate

  private enum Completion {
    case success(token: String)
    case cancelled

    init?(url: URL) {
      let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
      let statusItem = queryItems?.first { $0.name == "status" }
      let orderTokenItem = queryItems?.first { $0.name == "orderToken" }

      switch (statusItem?.value, orderTokenItem?.value) {
      case ("SUCCESS", let token?):
        self = .success(token: token)
      case ("CANCELLED", _):
        self = .cancelled
      default:
        return nil
      }
    }
  }

  private let externalLinkPathComponents = ["privacy-policy", "terms-of-service"]

  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    guard let url = navigationAction.request.url else {
      return decisionHandler(.allow)
    }

    let shouldOpenExternally = externalLinkPathComponents.contains(url.lastPathComponent)

    switch (shouldOpenExternally, Completion(url: url)) {
    case (true, _):
      decisionHandler(.cancel)
      UIApplication.shared.open(url)

    case (false, .success(let token)):
      decisionHandler(.cancel)
      dismiss(animated: true) { self.completion(.success(token: token)) }

    case (false, .cancelled):
      decisionHandler(.cancel)
      dismiss(animated: true) { self.completion(.cancelled(reason: .userInitiated)) }

    case (false, nil):
      decisionHandler(.allow)
    }
  }

  func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
    if webView == originWebView {
      originWebView.evaluateJavaScript("openAfterpay('\(checkoutURL.absoluteString)');")
    }
  }

  func webView(
    _ webView: WKWebView,
    didFailProvisionalNavigation navigation: WKNavigation!,
    withError error: Error
  ) {
    print(error as Any)
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
    checkoutWebView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    checkoutWebView.allowsLinkPreview = false
    checkoutWebView.navigationDelegate = self
    view.addSubview(checkoutWebView)

    return checkoutWebView
  }

  // MARK: WKScriptMessageHandler

  func userContentController(
    _ userContentController: WKUserContentController,
    didReceive message: WKScriptMessage
  ) {
    let decodeMessage = { data in
      try? JSONDecoder().decode(ExpressCheckoutMessage.self, from: data)
    }

    guard
      let json = message.body as? String,
      let message = json.data(using: .utf8).flatMap(decodeMessage),
      let handler = getExpressCheckoutHandler(),
      let targetURL = URL(string: "/", relativeTo: checkoutURL)?.absoluteURL
    else {
      return
    }

    let webView: WKWebView = originWebView
    let postMessage = { (message: ExpressCheckoutMessage) in
      let data = try? JSONEncoder().encode(message)
      let json = data.flatMap { String(data: $0, encoding: .utf8) } ?? "{}"
      let javascript = "postCheckoutMessage(JSON.parse('\(json)'), '\(targetURL.absoluteString)');"
      webView.evaluateJavaScript(javascript)
    }

    switch message.payload {
    case .address(let address):
      handler.shippingAddressDidChange(address: address) { options in
        postMessage(.init(requestId: message.requestId, payload: .shippingOptions(options)))
      }

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
