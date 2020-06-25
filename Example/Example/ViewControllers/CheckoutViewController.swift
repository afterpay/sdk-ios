//
//  PayWithAfterpayViewController.swift
//  Example
//
//  Created by Adam Campbell on 12/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import UIKit

final class CheckoutViewController: UIViewController {

  private let checkout: () -> Void
  private var checkoutView: CheckoutView { view as! CheckoutView }

  init(checkout: @escaping () -> Void) {
    self.checkout = checkout

    super.init(nibName: nil, bundle: nil)

    self.title = "Swift Checkout"
  }

  override func loadView() {
    view = CheckoutView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    checkoutView.payButton.addTarget(self, action: #selector(didTapPay), for: .touchUpInside)
  }

  // MARK: Checkout

  @objc private func didTapPay() {
    checkout()
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
