//
//  Configuration.swift
//  Afterpay
//
//  Created by Adam Campbell on 23/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

/// Describes errors encountered when constructing a `Configuration`
public enum ConfigurationError: LocalizedError, Equatable {

  case invalidMinimum(String)
  case invalidMaximum(String)
  case invalidOrdering(minimum: String, maximum: String)
  case invalidCurrencyCode(String)

  public var failureReason: String? {
    switch self {
    case .invalidMinimum(let minimum):
      return "Minimum (\(minimum)) is not convertible to a positive Decimal number"
    case .invalidMaximum(let maximum):
      return "Maximum (\(maximum)) is not convertible to a positive Decimal number"
    case .invalidOrdering(let minimum, let maximum):
      return "Minmum (\(minimum)) is not strictly less than maximum (\(maximum))"
    case .invalidCurrencyCode(let currencyCode):
      return "Currency code (\(currencyCode)) is not valid"
    }
  }

}

/// A configuration that should be constructed from the results of a call to `/v2/configuration`
public struct Configuration {

  let minimumAmount: Decimal?
  let maximumAmount: Decimal
  let currency: Currency

  /// Creates a new configuration by taking in a minimum and maximum amount as well as a currency
  /// code.
  ///
  /// These should be taken from the values supplied in `/v2/configuration` for example in the
  /// response JSON:
  ///
  ///     {
  ///         "minimumAmount": { "amount": "1.00", "currency": "AUD" },
  ///         "maximumAmount": { "amount": "2000.00", "currency":"AUD" }
  ///     }
  ///
  /// The matching initializer call would be:
  ///
  ///     Configuration(minimumAmount: "1.00", maximumAmount: "2000.00", currencyCode: "AUD")
  ///
  /// - Parameters:
  ///   - minimumAmount: An optional minimum amount string representation of a decimal number,
  ///   rounded to 2 decimal places. However values convertible to a Swift Decimal are accepted.
  ///   - maximumAmount: A amount string representation of a decimal number, rounded to 2
  ///   decimal places. However values convertible to a Swift Decimal are accepted.
  ///   - currencyCode: The currency in ISO 4217 format. Supported values include "AUD", "NZD",
  ///   "USD", and "CAD". However values recognized by Foundation are accepted.
  /// - Throws: A ConfigurationError describing why the configuration values were rejected.
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
