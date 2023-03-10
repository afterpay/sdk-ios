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
    formatter.numberStyle = .decimal
    formatter.minimumFractionDigits = 2
    formatter.maximumFractionDigits = 2
    return formatter.string(from: decimal as NSDecimalNumber)!
  }

  func displayString(from decimal: Decimal) -> String {
    let formatter = Self.formatter
    formatter.currencyCode = currencyCode
    let localCurrencyCode = Locale.current.currencyCode
    formatter.numberStyle = localCurrencyCode == currencyCode ? .currency : .currencyISOCode
    return formatter.string(from: decimal as NSDecimalNumber)!
  }
}
