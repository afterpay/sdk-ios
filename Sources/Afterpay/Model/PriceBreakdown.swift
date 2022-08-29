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

    let greaterThanZero = totalAmount > .zero
    let greaterThanOrEqualToMinimum = totalAmount >= (configuration?.minimumAmount ?? .zero)
    let lessThanOrEqualToMaximum = totalAmount <= (configuration?.maximumAmount ?? .zero)
    let inRange = greaterThanZero && greaterThanOrEqualToMinimum && lessThanOrEqualToMaximum
    let maxFractionDigits = !inRange ? 0 : nil

    let formatter = configuration
      .map { CurrencyFormatter(locale: $0.locale, currencyCode: $0.currencyCode, clientLocale: Locale.current) }
    let format = { formatter?.string(from: $0, maxDecimals: maxFractionDigits) }

    let formattedMinimum = configuration?.minimumAmount.flatMap(format) ??
      formatter?.string(from: 1, maxDecimals: maxFractionDigits)
    let formattedMaximum = (configuration?.maximumAmount).flatMap(format)
    let numberOfInstalments = getNumberOfInstalments(currencyCode: configuration?.currencyCode)
    let formattedPayment = format(totalAmount / numberOfInstalments)

    let isUkLocale = configuration?.locale == Locales.enGB
    let isGBP = configuration?.currencyCode == "GBP"

    let interestFreeText: String
    if isUkLocale || isGBP {
      interestFreeText = ""
    } else if showInterestFreeText {
      interestFreeText = Afterpay.string.localized.interestFree
    } else {
      interestFreeText = ""
    }

    let withText = showWithText ? Afterpay.string.localized.with : ""

    if let formattedPayment = formattedPayment, inRange {
      badgePlacement = .end

      string = String.localizedStringWithFormat(
        Afterpay.string.localized.availableTemplate,
        introText.localizedText,
        String(describing: numberOfInstalments),
        interestFreeText,
        formattedPayment,
        withText
      ).trimmingCharacters(in: .whitespaces)
    } else if let formattedMinimum = formattedMinimum, let formattedMaximum = formattedMaximum {
      badgePlacement = .start
      string = String.localizedStringWithFormat(
        Afterpay.string.localized.outsideLimitsTemplate,
        formattedMinimum, formattedMaximum
      )
    } else {
      badgePlacement = .end
      string = Afterpay.string.localized.orPayWith
    }
  }
}

internal func getNumberOfInstalments(currencyCode: String?) -> Decimal {
  return currencyCode == "EUR" && currencyCode != nil ? 3 : 4
}
