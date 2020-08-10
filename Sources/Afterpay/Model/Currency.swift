//
//  Currency.swift
//  Afterpay
//
//  Created by Adam Campbell on 10/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

private let posixLocale = Locale(identifier: "en_US_POSIX")
private let unknownCurrencyName = "Unknown Currency"

struct Currency {

  let code: String

  init?(currencyCode: String) {
    let currencyName = posixLocale.localizedString(forCurrencyCode: currencyCode)

    guard currencyName != nil, currencyName != unknownCurrencyName else {
      return nil
    }

    self.code = currencyCode
  }

}
