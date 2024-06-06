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
final class CheckoutWebViewController:
  UIViewController,
  UIAdaptivePresentationControllerDelegate,
  WKNavigationDelegate {

  private let checkoutUrl: URL
  private let shouldLoadRedirectUrls: Bool
  private let completion: (_ result: CheckoutResult) -> Void

  private var webView: WKWebView { view as! WKWebView }

  // MARK: Initialization

  init(
    checkoutUrl: URL,
    shouldLoadRedirectUrls: Bool,
    completion: @escaping (_ result: CheckoutResult) -> Void
  ) {
    self.checkoutUrl = checkoutUrl
    self.completion = completion
    self.shouldLoadRedirectUrls = shouldLoadRedirectUrls

    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    let config = WKWebViewConfiguration()
    config.applicationNameForUserAgent = WKWebViewConfiguration.appNameForUserAgent

    view = WKWebView(frame: .zero, configuration: config)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    if #available(iOS 13.0, *) {
      isModalInPresentation = true
      overrideUserInterfaceStyle = .light
    } else {
      navigationItem.rightBarButtonItem = UIBarButtonItem(
        title: "Cancel",
        style: .plain,
        target: self,
        action: #selector(presentCancelConfirmation)
      )
    }

    presentationController?.delegate = self

    webView.allowsLinkPreview = false
    webView.navigationDelegate = self
    webView.scrollView.bounces = false
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    guard
      let host = URLComponents(url: checkoutUrl, resolvingAgainstBaseURL: false)?.host,
      CheckoutHost.validSet.contains(host)
    else {
      return dismiss(animated: true) { [completion, checkoutUrl] in
        completion(.cancelled(reason: .invalidURL(checkoutUrl)))
      }
    }

    var request = URLRequest(url: checkoutUrl)
    request.setValue(Version.sdkVersion, forHTTPHeaderField: "X-Afterpay-SDK")

    webView.load(request)
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

  private enum Completion {
    case success(token: String)
    case cancelled

    init?(url: URL) {
      let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
      let statusItem = queryItems?.first { $0.name == "status" }
      let orderTokenItem = queryItems?.first { $0.name == "orderToken" || $0.name == "token" }

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

    let shouldOpenExternally = navigationAction.targetFrame == nil

    switch (shouldOpenExternally, Completion(url: url)) {
    case (true, _):
      decisionHandler(.cancel)
      UIApplication.shared.open(url)

    case (false, .success(let token)):
      if self.shouldLoadRedirectUrls {
        decisionHandler(.allow)
      } else {
        decisionHandler(.cancel)
        dismiss(animated: true) { self.completion(.success(token: token)) }
      }

    case (false, .cancelled):
      if self.shouldLoadRedirectUrls {
        decisionHandler(.allow)
      } else {
        decisionHandler(.cancel)
        dismiss(animated: true) { self.completion(.cancelled(reason: .userInitiated)) }
      }

    case (false, nil):
      decisionHandler(.allow)
    }
  }

  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationResponse: WKNavigationResponse,
    decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void
  ) {
    if !self.shouldLoadRedirectUrls {
      return decisionHandler(.allow)
    }

    let response = navigationResponse.response as? HTTPURLResponse
    guard let url = response?.url else {
      decisionHandler(.allow)
      dismiss(animated: true) { self.completion(.cancelled(reason: .unretrievableUrl)) }
      return
    }

    switch Completion(url: url) {
    case(.success(let token)):
      decisionHandler(.cancel)
      dismiss(animated: true) { self.completion(.success(token: token)) }

    case(.cancelled):
      decisionHandler(.cancel)
      dismiss(animated: true) { self.completion(.cancelled(reason: .userInitiated)) }

    case(nil):
      decisionHandler(.allow)

    }
  }

  func webView(
    _ webView: WKWebView,
    didFailProvisionalNavigation navigation: WKNavigation!,
    withError error: Error
  ) {
    let alert = Alerts.failedToLoad(
      retry: { [checkoutUrl] in
        webView.load(URLRequest(url: checkoutUrl))
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

}
