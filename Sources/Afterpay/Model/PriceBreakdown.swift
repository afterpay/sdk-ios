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

  init(
    totalAmount: Decimal,
    introText: AfterpayIntroText = AfterpayIntroText.or,
    showInterestFreeText: Bool = true,
    showWithText: Bool = true
  ) {
    let configuration = getConfiguration()
    let formatter = configuration
      .map { CurrencyFormatter(locale: $0.locale, currencyCode: $0.currencyCode, clientLocale: Locale.current) }
    let format = { formatter?.string(from: $0) }

    let formattedMinimum = configuration?.minimumAmount.flatMap(format) ?? formatter?.string(from: 1)
    let formattedMaximum = (configuration?.maximumAmount).flatMap(format)
    let numberOfInstalments = getNumberOfInstalments(currencyCode: configuration?.currencyCode)
    let formattedPayment = format(totalAmount / numberOfInstalments)

    let greaterThanZero = totalAmount > .zero
    let greaterThanOrEqualToMinimum = totalAmount >= (configuration?.minimumAmount ?? .zero)
    let lessThanOrEqualToMaximum = totalAmount <= (configuration?.maximumAmount ?? .zero)
    let inRange = greaterThanZero && greaterThanOrEqualToMinimum && lessThanOrEqualToMaximum

    let interestFreeText = showInterestFreeText ? Strings.interestFree : ""
    let withText = showWithText ? Strings.with : ""

    if let formattedPayment = formattedPayment, inRange {
      badgePlacement = .end

      string = String.localizedStringWithFormat(
        Strings.availableTemplate,
        introText.localizedText,
        String(describing: numberOfInstalments),
        interestFreeText,
        formattedPayment,
        withText
      ).trimmingCharacters(in: .whitespaces)
    } else if let formattedMinimum = formattedMinimum, let formattedMaximum = formattedMaximum {
      badgePlacement = .start
      string = String.localizedStringWithFormat(Strings.availableBetweenFormat, formattedMinimum, formattedMaximum)
    } else {
      badgePlacement = .end
      string = Strings.orPayWith
    }
  }
}

internal func getNumberOfInstalments(currencyCode: String?) -> Decimal {
  return currencyCode == "EUR" && currencyCode != nil ? 3 : 4
}
