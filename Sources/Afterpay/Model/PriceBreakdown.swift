//
//  PriceBreakdown.swift
//  Afterpay
//
//  Created by Adam Campbell on 10/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

private let formatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.numberStyle = .currency
  return formatter
}()

struct PriceBreakdown {

  enum BadgePlacement: Equatable {
    case start
    case end
  }

  let string: String
  let badgePlacement: BadgePlacement

  init(totalAmount: Decimal) {
    let configuration = getConfiguration()

    let format: (Decimal) -> String? = { formatter.string(from: $0 as NSDecimalNumber) }
    let formattedMinimum = configuration?.minimumAmount.flatMap(format)
    let formattedMaximum = (configuration?.maximumAmount).flatMap(format)
    let formattedInstalment = format(totalAmount / 4)

    let greaterThanZero = totalAmount > .zero
    let greaterThanOrEqualToMinimum = totalAmount >= (configuration?.minimumAmount ?? .zero)
    let lessThanOrEqualToMaximum = totalAmount <= (configuration?.maximumAmount ?? .zero)
    let inRange = greaterThanZero && greaterThanOrEqualToMinimum && lessThanOrEqualToMaximum

    if let formattedInstalment = formattedInstalment, inRange {
      badgePlacement = .end
      string = "or 4 instalments of \(formattedInstalment) with"
    } else if let formattedMinimum = formattedMinimum, let formattedMaximum = formattedMaximum {
      badgePlacement = .start
      string = "is available between \(formattedMinimum)-\(formattedMaximum)"
    } else if let formattedMaximum = formattedMaximum {
      badgePlacement = .start
      string = "is available under \(formattedMaximum)"
    } else {
      badgePlacement = .end
      string = "or pay with"
    }
  }

}
