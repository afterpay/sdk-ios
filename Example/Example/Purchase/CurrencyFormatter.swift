//
//  CurrencyFormatter.swift
//  Example
//
//  Created by Adam Campbell on 2/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

struct CurrencyFormatter {

  let currencyCode: String

  private static let formatter = NumberFormatter()

  func string(from decimal: Decimal) -> String {
    let formatter = Self.formatter
    formatter.numberStyle = .none
    return formatter.string(from: decimal as NSDecimalNumber)!
  }

  func displayString(from decimal: Decimal, showCurrencyCode: Bool = true) -> String {
    let formatter = Self.formatter
    formatter.currencyCode = currencyCode
    let localCurrencyCode = Locale.current.currencyCode
    formatter.currencySymbol = showCurrencyCode ? formatter.currencySymbol : ""
    formatter.currencyCode = showCurrencyCode ? formatter.currencyCode : ""

    if (localCurrencyCode == currencyCode) || !showCurrencyCode {
      formatter.numberStyle = .currency
    } else {
      formatter.numberStyle = .currencyISOCode
    }

    return formatter.string(from: decimal as NSDecimalNumber)!
  }
}
