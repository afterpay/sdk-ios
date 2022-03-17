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

  static let circledInfoIcon = "\u{24D8}"
  static let moreInfo = "More Info"
  static let learnMore = "Learn More"
  static let orPayWith = "or pay with"

  // MARK: - String Formats

  static let availableBetweenFormat = "available for orders between %@ - %@"
  static let availableUpToFormat = "available for orders up to %@"
  static let fourPaymentsFormatNoOptional = "%@ 4 payments of %@"
  static let fourPaymentsFormatWith = "%@ 4 payments of %@ with"
  static let fourPaymentsFormatInterest = "%@ 4 interest-free payments of %@"
  static let fourPaymentsFormatInterestAndWith = "%@ 4 interest-free payments of %@ with"

  // MARK: - Accessible Strings

  static let accessibleAfterpay = "after pay"
  static let accessibleClearpay = "clear pay"

}
