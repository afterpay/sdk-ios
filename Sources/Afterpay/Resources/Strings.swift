//
//  Strings.swift
//  Afterpay
//
//  Created by Adam Campbell on 12/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

// These should be transitioned to a `.strings` file once resource support is available for
// swift packages
enum Strings {

  // MARK: - Static Strings

  static let info = NSLocalizedString("Info", comment: "Modal link text")
  static let orPayWith = NSLocalizedString("or pay with", comment: "Price breakdown message when no config set")

  // MARK: - String Formats

  static let availableBetweenFormat = NSLocalizedString(
    "available for orders between %@ - %@",
    comment: "Price breakdown when value is outside limits"
  )

  static let availableTemplate = NSLocalizedString(
    "%1$@ 4 %2$@payments of %3$@ %4$@",
    comment: "Price breakdown text: 1. intro text 2. interest-free 3. instalment 4. with (suffix)"
  )

  // MARK: - Accessible Strings

  static let accessibleAfterpay = "after pay"
  static let accessibleClearpay = "clear pay"

}
