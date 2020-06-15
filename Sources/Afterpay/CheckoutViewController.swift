//
//  WebLoginViewController.swift
//  Afterpay
//
//  Created by Adam Campbell on 3/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import UIKit
import WebKit

public final class CheckoutViewController: UIViewController {
  private let url: URL

  private var webView: WKWebView { view as! WKWebView }

  public init(checkoutUrl: URL) {
    url = checkoutUrl

    super.init(nibName: nil, bundle: nil)
  }

  public override func loadView() {
    view = WKWebView()
  }

  public override func viewDidLoad() {
    super.viewDidLoad()

    webView.load(URLRequest(url: url))
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
