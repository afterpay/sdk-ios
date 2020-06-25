//
//  CheckoutView.swift
//  Example
//
//  Created by Adam Campbell on 24/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

@objcMembers final class CheckoutView: UIView {

  let payButton = UIButton(type: .system)

  override init(frame: CGRect) {
    super.init(frame: frame)

    if #available(iOS 13.0, *) {
      backgroundColor = .systemBackground
    } else {
      backgroundColor = .white
    }

    payButton.setTitle("Pay with Afterpay", for: .normal)
    payButton.translatesAutoresizingMaskIntoConstraints = false

    addSubview(payButton)

    NSLayoutConstraint.activate([
      payButton.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
      payButton.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
      payButton.centerYAnchor.constraint(equalTo: readableContentGuide.centerYAnchor),
    ])
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
