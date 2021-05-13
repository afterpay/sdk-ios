//
//  CurrencyFormatter.swift
//  Afterpay
//
//  Created by Adam Campbell on 16/10/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

private let formatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.numberStyle = .currency
  return formatter
}()

struct CurrencyFormatter {

  let locale: Locale
  let currencyCode: String

  func string(from decimal: Decimal) -> String? {
    if locale == Locales.unitedStates || locale.currencyCode == currencyCode {
      formatter.locale = locale
      formatter.currencyCode = currencyCode
      return formatter.string(from: decimal as NSDecimalNumber)
    } else {
      let currencyLocale = Locales.validSet.first { $0.currencyCode == currencyCode }
      formatter.locale = currencyLocale
      formatter.currencyCode = currencyCode
      let formattedString = formatter.string(from: decimal as NSDecimalNumber)
      return currencyLocale?.currencySymbol == Locales.unitedStates.currencySymbol
        ? formattedString?.appending(" \(currencyCode)")
        : formattedString
    }
  }

}
