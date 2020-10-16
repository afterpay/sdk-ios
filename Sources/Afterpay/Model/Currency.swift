//
//  Currency.swift
//  Afterpay
//
//  Created by Adam Campbell on 10/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

private let unknownCurrencyName = "Unknown Currency"

struct Currency {

  let code: String

  var symbol: String {
    switch code {
    case Locales.australia.currencyCode:
      return "A$"
    case Locales.newZealand.currencyCode:
      return "NZ$"
    case Locales.canada.currencyCode:
      return "CA$"
    default:
      return "$"
    }
  }

  init?(currencyCode: String) {
    let currencyName = Locales.posix.localizedString(forCurrencyCode: currencyCode)

    guard currencyName != nil, currencyName != unknownCurrencyName else {
      return nil
    }

    self.code = currencyCode
  }

}
