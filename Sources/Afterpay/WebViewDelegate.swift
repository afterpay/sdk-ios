//
//  WebViewDelegate.swift
//  Afterpay
//
//  Created by Ryan Davis on 3/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import WebKit

final class WebViewDelegate: NSObject, WKNavigationDelegate {
  private let externalLinkPathComponents = ["privacy-policy", "terms-of-service"]

  private let completion: (_ result: CheckoutResult) -> Void

  init(completion: @escaping (_ result: CheckoutResult) -> Void) {
    self.completion = completion
  }

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
      completion(.success(token: token))

    case (false, .cancelled):
      decisionHandler(.cancel)
      completion(.cancelled)

    case (false, nil):
      decisionHandler(.allow)
    }
  }
}
