//
//  InfoWebViewController.swift
//  Afterpay
//
//  Created by Ryan Davis on 7/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit
import WebKit

final class InfoWebViewController: UIViewController, WKNavigationDelegate {

  private let infoURL: URL

  private var webView: WKWebView { view as! WKWebView }

  init(infoURL: URL) {
    self.infoURL = infoURL

    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    let webView = WKWebView()
    webView.allowsLinkPreview = false
    webView.navigationDelegate = self
    view = webView
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    self.extendedLayoutIncludesOpaqueBars = true

    if #available(iOS 13.0, *) {
      overrideUserInterfaceStyle = .light
      navigationItem.rightBarButtonItem = UIBarButtonItem(
        barButtonSystemItem: .close,
        target: self,
        action: #selector(dismissViewController)
      )
    } else {
      navigationItem.rightBarButtonItem = UIBarButtonItem(
        title: "Close",
        style: .plain,
        target: self,
        action: #selector(dismissViewController)
      )
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    webView.load(URLRequest(url: infoURL))
  }

  @objc private func dismissViewController() {
    dismiss(animated: true)
  }

  // MARK: WKNavigationDelegate

  func webView(
    _ webView: WKWebView,
    didFailProvisionalNavigation navigation: WKNavigation!,
    withError error: Error
  ) {
    let alert = UIAlertController(
      title: "Error",
      message: "Failed to load Afterpay information",
      preferredStyle: .alert
    )

    alert.addAction(
      UIAlertAction(title: "Retry", style: .default) { [infoURL] _ in
        webView.load(URLRequest(url: infoURL))
      }
    )
    alert.addAction(
      UIAlertAction(title: "Cancel", style: .destructive) { _ in
        self.dismiss(animated: true)
      }
    )

    present(alert, animated: true, completion: nil)
  }

  func webView(
    _ webView: WKWebView,
    decidePolicyFor navigationAction: WKNavigationAction,
    decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
  ) {
    if let url = navigationAction.request.url, url != infoURL {
      decisionHandler(.cancel)
      UIApplication.shared.open(url)
    } else {
      decisionHandler(.allow)
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
