//
//  CurrencyFormatter.swift
//  Afterpay
//
//  Created by Adam Campbell on 16/10/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

struct CurrencyFormatter {

  let locale: Locale
  let currencyCode: String
  let clientLocale: Locale

  private let formatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .currency
    return formatter
  }()

  func string(from decimal: Decimal, maxDecimals: Int? = nil) -> String? {
    formatter.locale = clientLocale

    let currencyLocales = Locales.validArray.filter { $0.currencyCode == currencyCode }
    let currencyLocale: Locale?

    if currencyLocales.count == 1 {
      currencyLocale = currencyLocales.first
    } else if currencyLocales.contains(locale) {
      currencyLocale = locale
    } else {
      currencyLocale = Locales.validArray.first { $0.currencyCode == currencyCode }
    }

    formatter.currencyCode = currencyCode

    let currencySymbol = currencyLocale?.currencySymbol

    let usCurrencySymbol = Locales.enUS.currencySymbol
    let gbCurrencySymbol = Locales.enGB.currencySymbol
    let euCurrencySymbol = Locales.frFR.currencySymbol

    if clientLocale == Locales.enUS {
      if currencySymbol == euCurrencySymbol {
        formatter.positiveFormat = "#,##0.00¤"
      }
    } else if clientLocale.currencyCode != locale.currencyCode {
      formatter.currencySymbol = currencySymbol

      switch currencySymbol {
      case usCurrencySymbol:
        formatter.positivePrefix = currencySymbol
        formatter.positiveFormat = "¤#,##0.00 ¤¤"
      case gbCurrencySymbol:
        formatter.positiveFormat = "¤#,##0.00"
      case euCurrencySymbol:
        formatter.positiveFormat = "#,##0.00¤"
      default:
        formatter.positiveFormat = formatter.positiveFormat
      }
    }
    if maxDecimals != nil {
      formatter.maximumFractionDigits = maxDecimals!
    }

    return formatter.string(from: decimal as NSDecimalNumber)
  }

}
