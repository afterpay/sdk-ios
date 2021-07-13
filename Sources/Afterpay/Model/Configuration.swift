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
  case invalidLocale(Locale)

  public var failureReason: String? {
    switch self {
    case .invalidMinimum(let minimum):
      return "Minimum (\(minimum)) is not convertible to a positive Decimal number"
    case .invalidMaximum(let maximum):
      return "Maximum (\(maximum)) is not convertible to a positive Decimal number"
    case .invalidOrdering(let minimum, let maximum):
      return "Minimum (\(minimum)) is not strictly less than maximum (\(maximum))"
    case .invalidCurrencyCode(let currencyCode):
      return "Currency code (\(currencyCode)) is not valid"
    case .invalidLocale(let locale):
      return "Locale with identifier (\(locale.identifier)) is not valid"
    }
  }

}

/// A configuration that should be constructed from the results of a call to `/v2/configuration`
public struct Configuration {

  public var minimumAmount: Decimal?
  public var maximumAmount: Decimal
  public var currencyCode: String
  public var locale: Locale
  public var environment: Environment

  /// Creates a new configuration by taking in a minimum and maximum amount as well as a currency
  /// code and locale.
  ///
  /// The locale provided should match the locale for the API endpoint in use and the required terms
  /// and conditions. For example when using https://api.afterpay.com and the Australian terms and
  /// conditions the locale should be constructed with the identifier "en_AU".
  ///
  /// The remaining values should be taken from the parameters supplied in `/v2/configuration` for
  /// example in the response JSON:
  ///
  ///     {
  ///         "minimumAmount": { "amount": "1.00", "currency": "AUD" },
  ///         "maximumAmount": { "amount": "2000.00", "currency":"AUD" }
  ///     }
  ///
  /// The matching initializer call would be:
  ///
  ///     Configuration(
  ///         minimumAmount: "1.00",
  ///         maximumAmount: "2000.00",
  ///         currencyCode: "AUD",
  ///         locale: Locale(identifier: "en_AU")
  ///     )
  ///
  /// - Parameters:
  ///   - minimumAmount: An optional minimum amount string representation of a decimal number,
  ///   rounded to 2 decimal places. However values convertible to a Swift Decimal are accepted.
  ///   - maximumAmount: A amount string representation of a decimal number, rounded to 2
  ///   decimal places. However values convertible to a Swift Decimal are accepted.
  ///   - currencyCode: The currency in ISO 4217 format. Supported values include "AUD", "CAD",
  ///   "GBP", "NZD" and "USD".
  ///   - locale: The locale required for display of the appropriate terms and conditions and used
  ///   for formatting of currency. For example if the locale is set to en_AU are specified as USD.
  ///   More examples are available in the currency tab of the js sandbox:
  ///   https://js.sandbox.afterpay.com/index.html
  /// - Throws: A ConfigurationError describing why the configuration values were rejected.
  public init(
    minimumAmount: String?,
    maximumAmount: String,
    currencyCode: String,
    locale: Locale,
    environment: Environment
  ) throws {
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

    guard Locales.validSet.map(\.currencyCode).contains(currencyCode) else {
      throw ConfigurationError.invalidCurrencyCode(currencyCode)
    }

    guard Locales.validSet.contains(locale) else {
      throw ConfigurationError.invalidLocale(locale)
    }

    self.minimumAmount = minimumDecimal
    self.maximumAmount = maximumDecimal
    self.currencyCode = currencyCode
    self.locale = locale
    self.environment = environment
  }

  init(_ object: Object, configuration: CheckoutV3Configuration) throws {
    try self.init(
      minimumAmount: object.minimumAmount.amount,
      maximumAmount: object.maximumAmount.amount,
      currencyCode: configuration.region.currencyCode,
      locale: configuration.region.locale,
      environment: configuration.environment
    )
  }

  struct Object: Decodable {
    let minimumAmount: Money
    let maximumAmount: Money
  }

}
