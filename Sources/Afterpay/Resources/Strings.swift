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

  static let moreInfo = NSLocalizedString(
    "MORE_INFO",
    tableName: "Placement",
    bundle: Bundle.apResource,
    value: "More Info",
    comment: "Link in price breakdown message"
  )

  static let orPayWith = NSLocalizedString(
    "OR_PAY_WITH",
    tableName: "Placement",
    bundle: Bundle.apResource,
    value: "or pay with",
    comment: "Price breakdown message when no config set"
  )

  static let learnMore = NSLocalizedString(
    "LEARN_MORE",
    tableName: "Placement",
    bundle: Bundle.apResource,
    value: "Learn More",
    comment: "Link in price breakdown message"
  )

  static let circledInfoIcon = "\u{24D8}"

  // MARK: - String Formats

  static let availableBetweenFormat = NSLocalizedString(
    "OUTSIDE_LIMITS",
    tableName: "Placement",
    bundle: Bundle.apResource,
    value: "available for orders between %1$@ – %2$@",
    comment: "Price breakdown when value is outside limits"
  )

  static let availableTemplate = NSLocalizedString(
    "AVAILABLE_TEMPLATE",
    tableName: "Placement",
    bundle: Bundle.apResource,
    value: "%1$@ 4 %2$@payments of %3$@ %4$@",
    comment: "Price breakdown text: 1. intro text 2. interest-free 3. instalment 4. with (suffix)"
  )

  static let interestFree = NSLocalizedString(
    "INTEREST_FREE",
    tableName: "Placement",
    bundle: Bundle.apResource,
    value: "interest-free ",
    comment: "Interest-free words for price breakdown"
  )

  static let with = NSLocalizedString(
    "WITH",
    tableName: "Placement",
    bundle: Bundle.apResource,
    value: "with",
    comment: "With word (suffix) in pricebreakdown"
  )

  // MARK: - Accessible Strings

  static let accessibleAfterpay = "after pay"
  static let accessibleClearpay = "clear pay"

}
