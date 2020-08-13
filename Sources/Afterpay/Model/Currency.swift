//
//  Currency.swift
//  Afterpay
//
//  Created by Adam Campbell on 10/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

private let posixLocale = Locale(identifier: "en_US_POSIX")
private let australianLocale = Locale(identifier: "en_AU")
private let newZealandLocale = Locale(identifier: "en_NZ")
private let unitedStatesLocale = Locale(identifier: "en_US")
private let canadianLocale = Locale(identifier: "en_CA")
private let unknownCurrencyName = "Unknown Currency"

struct Currency {

  let code: String

  var symbol: String {
    switch code {
    case australianLocale.currencyCode:
      return "A$"
    case newZealandLocale.currencyCode:
      return "NZ$"
    case canadianLocale.currencyCode:
      return "CA$"
    case unitedStatesLocale.currencyCode:
      fallthrough // swiftlint:disable:this no_fallthrough_only
    default:
      return "$"
    }
  }

  init?(currencyCode: String) {
    let currencyName = posixLocale.localizedString(forCurrencyCode: currencyCode)

    guard currencyName != nil, currencyName != unknownCurrencyName else {
      return nil
    }

    self.code = currencyCode
  }

}
