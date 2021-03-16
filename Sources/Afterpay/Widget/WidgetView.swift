//
//  WidgetView.swift
//  Afterpay
//
//  Created by Huw Rowlands on 11/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit
import WebKit

public final class WidgetView: UIView, WKNavigationDelegate, WKScriptMessageHandler {

  private var webView: WKWebView!
  private let token: String

  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()

  public init(token: String) {
    precondition(
      AfterpayFeatures.widgetEnabled,
      "`WidgetView` is experimental. Enable by passing launch argument `-com.afterpay.widget-enabled YES`."
    )

    self.token = token

    super.init(frame: .zero)

    setupWebView()
    setupConstraints()
  }

  // MARK: Subviews

  private func setupWebView() {
    let preferences = WKPreferences()
    preferences.javaScriptEnabled = true
    preferences.javaScriptCanOpenWindowsAutomatically = true

    let userContentController = WKUserContentController()
    userContentController.add(self, name: "iOS")

    let bootstrapConfiguration = WKWebViewConfiguration()
    bootstrapConfiguration.processPool = WKProcessPool()
    bootstrapConfiguration.preferences = preferences
    bootstrapConfiguration.userContentController = userContentController

    webView = WKWebView(frame: .zero, configuration: bootstrapConfiguration)
    webView.navigationDelegate = self
    webView.allowsLinkPreview = false
    webView.scrollView.isScrollEnabled = false

    webView.load(URLRequest(url: URL(string: "http://localhost:8000/widget-bootstrap.html")!))

    addSubview(webView)
  }

  public override func willMove(toSuperview newSuperview: UIView?) {
    if newSuperview == nil {
      webView.configuration.userContentController.removeScriptMessageHandler(forName: "iOS")
    }
  }

  private func setupConstraints() {
    webView.translatesAutoresizingMaskIntoConstraints = false

    let webViewConstraints = [
      webView.leadingAnchor.constraint(equalTo: leadingAnchor),
      webView.trailingAnchor.constraint(equalTo: trailingAnchor),
      webView.topAnchor.constraint(equalTo: topAnchor),
      webView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ]

    NSLayoutConstraint.activate(webViewConstraints)
  }

  public func sendUpdate(amount: String) {
    guard
      let currencyCode = getConfiguration()?.currencyCode,
      let data = try? encoder.encode(Money(amount: amount, currency: currencyCode)),
      let json = String(data: data, encoding: .utf8)
    else {
      return
    }

    webView.evaluateJavaScript(#"update(\#(json))"#)
  }

  // MARK: WKNavigationDelegate

  public func webView(
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

  public func webView(_ webView: WKWebView, didFinish _: WKNavigation!) {
    let javaScript = #"createAfterpayWidget("\#(self.token)");"#
    self.webView.evaluateJavaScript(javaScript)
  }

  // MARK: WKScriptMessageHandler

  public func userContentController(
    _ userContentController: WKUserContentController,
    didReceive message: WKScriptMessage
  ) {
    guard
      let jsonData = (message.body as? String)?.data(using: .utf8),
      let widgetEvent = try? decoder.decode(WidgetEvent.self, from: jsonData)
    else {
      return
    }

    getWidgetHandler()?.didReceiveEvent(widgetEvent)
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

private extension WidgetHandler {

  func didReceiveEvent(_ event: WidgetEvent) {

    switch event {
    case let .change(status):
      onChanged(status: status)

    case let .error(errorCode, message):
      onError(errorCode: errorCode, message: message)

    case let .ready(isValid, amountDue, checksum):
      onReady(isValid: isValid, amountDueToday: amountDue, paymentScheduleChecksum: checksum)
    }

  }

}
