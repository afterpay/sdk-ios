//
//  Buttons.swift
//  Example
//
//  Created by Adam Campbell on 13/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

extension UIButton {
  static var primaryButton: UIButton {
    let button = UIButton(type: .system)
    button.backgroundColor = .afterpayAccent
    button.setTitleColor(.white, for: .normal)
    button.setTitleColor(UIColor(white: 1, alpha: 0.5), for: .disabled)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
    return button
  }
}
