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

  init(checkout: @escaping () -> Void) {
    self.checkout = checkout

    super.init(nibName: nil, bundle: nil)

    self.title = "Checkout"
  }

  override func loadView() {
    view = UIView()

    if #available(iOS 13.0, *) {
      view.backgroundColor = .systemBackground
    } else {
      view.backgroundColor = .white
    }

    let payButton = UIButton(type: .system)
    payButton.setTitle("Pay with Afterpay", for: .normal)
    payButton.addTarget(self, action: #selector(didTapPay), for: .touchUpInside)
    payButton.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(payButton)

    let layoutGuide = view.readableContentGuide

    NSLayoutConstraint.activate([
      payButton.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      payButton.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
      payButton.centerYAnchor.constraint(equalTo: layoutGuide.centerYAnchor),
    ])
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
