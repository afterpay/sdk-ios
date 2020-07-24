//
//  Configuration.swift
//  Afterpay
//
//  Created by Adam Campbell on 23/7/20.
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

public enum ConfigurationError: Error {
  case invalidDecimal(String)
  case invalidCurrencyCode(String)
}

public struct Configuration {

  let minimumAmount: Decimal?
  let maximumAmount: Decimal
  let currency: Currency

  public init(minimumAmount: String?, maximumAmount: String, currencyCode: String) throws {
    let minimumSupplied = minimumAmount != nil
    let minimumDecimalAmount = minimumAmount.flatMap { Decimal(string: $0) }

    guard !minimumSupplied || (minimumSupplied && minimumDecimalAmount != nil) else {
      throw ConfigurationError.invalidDecimal(minimumAmount!)
    }

    guard let maximumDecimalAmount = Decimal(string: maximumAmount) else {
      throw ConfigurationError.invalidDecimal(maximumAmount)
    }

    guard let currency = Currency(currencyCode: currencyCode) else {
      throw ConfigurationError.invalidCurrencyCode(currencyCode)
    }

    self.minimumAmount = minimumDecimalAmount
    self.maximumAmount = maximumDecimalAmount
    self.currency = currency
  }

}
