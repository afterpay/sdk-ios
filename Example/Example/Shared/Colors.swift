//
//  Colors.swift
//  Example
//
//  Created by Adam Campbell on 13/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

extension UIColor {

  // MARK: Brand Colors

  static let afterpayBlue = UIColor(red: 22, green: 160, blue: 213)
  static let afterpayNavy = UIColor(red: 7, green: 69, blue: 120)

  // MARK: Semantic Colors

  static let afterpayAccent = UIColor(lightColor: .afterpayNavy, darkColor: .afterpayBlue)

  // MARK: Convenience Initializers

  private convenience init(red: UInt, green: UInt, blue: UInt) {
    let red = CGFloat(red) / 255
    let green = CGFloat(green) / 255
    let blue = CGFloat(blue) / 255

    self.init(red: red, green: green, blue: blue, alpha: 1.0)
  }

  private convenience init(lightColor: UIColor, darkColor: UIColor) {
    if #available(iOS 13.0, *) {
      self.init { traitCollection -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .dark:
          return darkColor
        case .light, .unspecified:
          fallthrough
        @unknown default:
          return lightColor
        }
      }
    } else {
      self.init(cgColor: lightColor.cgColor)
    }
  }

}
