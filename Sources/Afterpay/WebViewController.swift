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
  private let completion: (_ result: CheckoutResult) -> Void
  // swiftlint:disable:next weak_delegate
  private var webViewDelegate: WebViewDelegate?

  private var webView: WKWebView { view as! WKWebView }

  // MARK: Initialization

  init(
    checkoutUrl: URL,
    completion: @escaping (_ result: CheckoutResult) -> Void
  ) {
    self.checkoutUrl = checkoutUrl
    self.completion = completion

    super.init(nibName: nil, bundle: nil)

    self.webViewDelegate = WebViewDelegate { [weak self] result in
      self?.dismiss(animated: true) {
        completion(result)
      }
    }
  }

  override func loadView() {
    view = WKWebView()
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

    presentationController?.delegate = self

    webView.allowsLinkPreview = false
    webView.navigationDelegate = webViewDelegate
    webView.load(URLRequest(url: checkoutUrl))
  }

  // MARK: UIAdaptivePresentationControllerDelegate

  func presentationControllerShouldDismiss(
    _ presentationController: UIPresentationController
  ) -> Bool {
    return false
  }

  func presentationControllerDidAttemptToDismiss(
    _ presentationController: UIPresentationController
  ) {
    presentCancelConfirmation()
  }

  // MARK: Actions

  @objc private func presentCancelConfirmation() {
    let actionSheet = UIAlertController(
      title: "Are you sure you want to cancel the payment?",
      message: nil,
      preferredStyle: .actionSheet
    )

    let cancelPayment: (UIAlertAction) -> Void = { _ in
      self.dismiss(animated: true) { self.completion(.cancelled) }
    }

    let actions = [
      UIAlertAction(title: "Yes", style: .destructive, handler: cancelPayment),
      UIAlertAction(title: "No", style: .cancel, handler: nil),
    ]

    actions.forEach(actionSheet.addAction)

    present(actionSheet, animated: true, completion: nil)
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
