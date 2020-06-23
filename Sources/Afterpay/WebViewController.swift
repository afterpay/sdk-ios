//
//  WebLoginViewController.swift
//  Afterpay
//
//  Created by Adam Campbell on 3/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import UIKit
import WebKit

// swiftlint:disable:next colon
final class WebViewController:
  UIViewController,
  UIAdaptivePresentationControllerDelegate,
  WKNavigationDelegate
{ // swiftlint:disable:this opening_brace

  private let checkoutUrl: URL
  private let cancelHandler: () -> Void
  private let successHandler: (_ token: String) -> Void

  private var webView: WKWebView { view as! WKWebView }

  // MARK: Initialization

  init(
    checkoutUrl: URL,
    cancelHandler: @escaping () -> Void,
    successHandler: @escaping (_ token: String) -> Void
  ) {
    self.checkoutUrl = checkoutUrl
    self.cancelHandler = cancelHandler
    self.successHandler = successHandler

    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    view = WKWebView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    presentationController?.delegate = self

    webView.navigationDelegate = self
    webView.load(URLRequest(url: checkoutUrl))
  }

  // MARK: UIAdaptivePresentationControllerDelegate

  func presentationControllerShouldDismiss(
    _ presentationController: UIPresentationController
  ) -> Bool {
    let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
    let dismiss: (UIAlertAction) -> Void = { _ in
      self.dismiss(animated: true, completion: self.cancelHandler)
    }

    let actions = [
      UIAlertAction(title: "Discard Payment", style: .destructive, handler: dismiss),
      UIAlertAction(title: "Cancel", style: .cancel, handler: nil),
    ]

    actions.forEach(actionSheet.addAction)

    present(actionSheet, animated: true, completion: nil)

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
      dismiss(animated: true) { self.successHandler(token) }

    case (false, .cancelled):
      decisionHandler(.cancel)
      dismiss(animated: true, completion: self.cancelHandler)

    case (false, nil):
      decisionHandler(.allow)
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
