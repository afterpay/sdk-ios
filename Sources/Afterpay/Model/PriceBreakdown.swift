//
//  PriceBreakdown.swift
//  Afterpay
//
//  Created by Adam Campbell on 10/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

struct PriceBreakdown {

  enum BadgePlacement: Equatable {
    case start
    case end
  }

  let string: String
  let badgePlacement: BadgePlacement

  init(totalAmount: Decimal) {
    let configuration = getConfiguration()
    let formatter = CurrencyFormatter(locale: configuration?.locale ?? Locales.unitedStates)

    let formattedMinimum = configuration?.minimumAmount.flatMap(formatter.string)
    let formattedMaximum = (configuration?.maximumAmount).flatMap(formatter.string)
    let formattedPayment = formatter.string(from: totalAmount / 4)

    let greaterThanZero = totalAmount > .zero
    let greaterThanOrEqualToMinimum = totalAmount >= (configuration?.minimumAmount ?? .zero)
    let lessThanOrEqualToMaximum = totalAmount <= (configuration?.maximumAmount ?? .zero)
    let inRange = greaterThanZero && greaterThanOrEqualToMinimum && lessThanOrEqualToMaximum

    if let formattedPayment = formattedPayment, inRange {
      badgePlacement = .end
      string = String(format: Strings.fourPaymentsFormat, formattedPayment)
    } else if let formattedMinimum = formattedMinimum, let formattedMaximum = formattedMaximum {
      badgePlacement = .start
      string = String(format: Strings.availableBetweenFormat, formattedMinimum, formattedMaximum)
    } else if let formattedMaximum = formattedMaximum {
      badgePlacement = .start
      string = String(format: Strings.availableUpToFormat, formattedMaximum)
    } else {
      badgePlacement = .end
      string = Strings.orPayWith
    }
  }

}
