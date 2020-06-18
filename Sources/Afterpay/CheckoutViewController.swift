//
//  WebLoginViewController.swift
//  Afterpay
//
//  Created by Adam Campbell on 3/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import UIKit
import WebKit

final class CheckoutViewController: UIViewController, WKNavigationDelegate {

  private let checkoutUrl: URL
  private let successHandler: (_ token: String) -> Void

  private var webView: WKWebView { view as! WKWebView }

  // MARK: Initialization

  init(checkoutUrl: URL, successHandler: @escaping (_ token: String) -> Void) {
    self.checkoutUrl = checkoutUrl
    self.successHandler = successHandler

    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    view = WKWebView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    webView.navigationDelegate = self
    webView.load(URLRequest(url: checkoutUrl))
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

  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    let completion = navigationAction.request.url.flatMap(Completion.init(url:))

    switch completion {
    case .success(let token):
      decisionHandler(.cancel)
      dismiss(animated: true) { self.successHandler(token) }
    case .cancelled:
      decisionHandler(.cancel)
      dismiss(animated: true, completion: nil)
    case nil:
      decisionHandler(.allow)
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
