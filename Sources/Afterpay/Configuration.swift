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
  case invalidMinimum(String)
  case invalidMaximum(String)
  case invalidOrdering(minimum: String, maximum: String)
  case invalidCurrencyCode(String)
}

public struct Configuration {

  let minimumAmount: Decimal?
  let maximumAmount: Decimal
  let currency: Currency

  public init(minimumAmount: String?, maximumAmount: String, currencyCode: String) throws {
    let minimumSupplied = minimumAmount != nil
    let minimumDecimal = minimumAmount.flatMap { Decimal(string: $0) }
    let minimumIsNotNegative = minimumDecimal ?? .zero >= .zero
    let minimumIsValid = minimumSupplied && minimumDecimal != nil && minimumIsNotNegative

    guard !minimumSupplied || minimumIsValid else {
      throw ConfigurationError.invalidMinimum(minimumAmount!)
    }

    guard let maximumDecimal = Decimal(string: maximumAmount), maximumDecimal >= .zero else {
      throw ConfigurationError.invalidMaximum(maximumAmount)
    }

    guard !minimumSupplied || minimumDecimal! < maximumDecimal else {
      throw ConfigurationError.invalidOrdering(minimum: minimumAmount!, maximum: maximumAmount)
    }

    guard let currency = Currency(currencyCode: currencyCode) else {
      throw ConfigurationError.invalidCurrencyCode(currencyCode)
    }

    self.minimumAmount = minimumDecimal
    self.maximumAmount = maximumDecimal
    self.currency = currency
  }

}
