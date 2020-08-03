//
//  PriceBreakdownView.swift
//  Afterpay
//
//  Created by Adam Campbell on 3/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public final class PriceBreakdownView: UIView {

  private let label = UILabel()

  public init() {
    super.init(frame: .zero)

    sharedInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    sharedInit()
  }

  private func sharedInit() {
    let attributedString = NSMutableAttributedString(string: "or 4 payments of $40.00 with")

    label.attributedText = attributedString

    if #available(iOS 13.0, *) {
      label.textColor = .label
    } else {
      label.textColor = .black
    }

    addSubview(label)

    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: leadingAnchor),
      label.topAnchor.constraint(equalTo: topAnchor),
      label.trailingAnchor.constraint(equalTo: trailingAnchor),
      label.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

}
