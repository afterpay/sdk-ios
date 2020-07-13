//
//  Colors.swift
//  Example
//
//  Created by Adam Campbell on 13/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

extension UIColor {
  static let afterpayBlue = UIColor(red: 22, green: 160, blue: 213)
  static let afterpayNavy = UIColor(red: 7, green: 69, blue: 120)

  static var afterpayAccent: UIColor {
    if #available(iOS 13.0, *) {
      return UIColor { traitCollection -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .dark:
          return .afterpayBlue
        case .light, .unspecified:
          return .afterpayNavy
        @unknown default:
          return .afterpayNavy
        }
      }
    } else {
      return .afterpayNavy
    }
  }

  private convenience init(red: UInt, green: UInt, blue: UInt) {
    let red = CGFloat(red) / 255
    let green = CGFloat(green) / 255
    let blue = CGFloat(blue) / 255

    self.init(red: red, green: green, blue: blue, alpha: 1.0)
  }
}
