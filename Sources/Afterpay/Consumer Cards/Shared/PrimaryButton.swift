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

    setBackgroundColor(UIColor.primaryColor, for: .normal)
    layer.cornerRadius = 12
    layer.masksToBounds = true

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

extension UIButton {

  /// Creates blank background image filled with specified color for the specified state
  /// - Parameters:
  ///   - color: The color used as a blank background image
  ///   - forState: The state that uses the specified image.
  func setBackgroundColor(_ color: UIColor, for forState: UIControl.State) {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)

    UIGraphicsBeginImageContext(rect.size)

    guard let currentContext = UIGraphicsGetCurrentContext() else {
      return
    }

    currentContext.setFillColor(color.cgColor)
    currentContext.fill(rect)

    let imageWithColor = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()

    setBackgroundImage(imageWithColor, for: forState)
  }

}
