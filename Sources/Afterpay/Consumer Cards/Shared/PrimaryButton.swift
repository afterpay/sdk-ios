//
//  PrimaryButton.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 15/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class PrimaryButton: UIButton {

  init(title: String, withLogo: Bool = false) {
    super.init(frame: .zero)

    backgroundColor = UIColor.primaryColor
    layer.cornerRadius = 12

    setTitleColor(.black, for: .normal)
    setTitle(title, for: .normal)

    let font = UIFont.systemFont(ofSize: 16, weight: .bold)
    titleLabel?.adjustsFontForContentSizeCategory = true
    titleLabel?.font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
