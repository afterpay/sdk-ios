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

  enum WidgetError: Error {
    /// An error occurred while executing some JavaScript. The error is included as an associated value.
    case javaScriptError(source: Error? = nil)
  }

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

    webView.load(
      URLRequest(
        url: URL(string: "http://localhost:8000/widget-bootstrap.html")!,
        cachePolicy: .reloadIgnoringLocalCacheData
      )
    )

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

  // MARK: Public methods

  /// Inform the widget about a change to the order total.
  ///
  /// Any time the order total changes (for example, a change of shipping option, promo code, or cart contents),
  /// the widget must be notified of the new amount.
  ///
  /// - Parameter amount: The order total as a String. Must be in the same currency that was sent to
  /// `Afterpay.setConfiguration`.
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

  /// Enquire about the status of the widget.
  ///
  /// The method sends the current `WidgetStatus` (or an error) to the completion handler. The completion handler always
  /// runs on the main thread.
  ///
  /// - Parameter completion: Completion handler called with a `Result` containing the `WidgetStatus`.
  ///
  /// # See also
  /// `WidgetStatus` for information about what kind of statuses the method returns.
  public func getStatus(completion: @escaping (Result<WidgetStatus, Error>) -> Void) {
    webView.evaluateJavaScript(#"getWidgetStatus()"#) { [decoder] returnValue, error in
      guard
        let jsonData = (returnValue as? String)?.data(using: .utf8),
        error != nil
      else {
        completion(.failure(WidgetError.javaScriptError(source: error)))
        return
      }

      do {
        let status = try decoder.decode(WidgetStatus.self, from: jsonData)

        completion(.success(status))
      } catch {
        completion(.failure(error))
      }
    }
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
    let jsonData = (message.body as? String)?.data(using: .utf8)

    do {
      let widgetEvent = try decoder.decode(WidgetEvent.self, from: jsonData ?? Data())
      getWidgetHandler()?.didReceiveEvent(widgetEvent)

    } catch {
      getWidgetHandler()?.onFailure(error: error)
    }
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
