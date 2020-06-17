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

  private let url: URL

  private var webView: WKWebView { view as! WKWebView }

  // MARK: Initialization

  init(checkoutUrl: URL) {
    url = checkoutUrl

    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    view = WKWebView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    webView.navigationDelegate = self
    webView.load(URLRequest(url: url))
  }

  // MARK: WKNavigationDelegate

  private enum Status: String {
    private static let name = "status"

    case cancelled = "CANCELLED"

    init?(url: URL) {
      let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
      let queryItem = urlComponents?.queryItems?.first { $0.name == Status.name }

      if let status = queryItem?.value.flatMap(Status.init(rawValue:)) {
        self = status
      } else {
        return nil
      }
    }
  }

  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    let status = navigationAction.request.url.flatMap(Status.init(url:))

    switch status {
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
