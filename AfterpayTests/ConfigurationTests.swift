//
//  ConfigurationTests.swift
//  AfterpayTests
//
//  Created by Adam Campbell on 24/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import XCTest

class ConfigurationTests: XCTestCase {

  let one = "1.00"
  let oneThousand = "1000.00"
  let invalidAlphaAmount = "foo"
  let negativeAmount = "-1.00"

  let usdCode = "USD"
  let invalidCode = "XXX"

  let usLocale = Locale(identifier: "en_US")

  func testValidConfiguration() {
    XCTAssertNoThrow(
      try Configuration(
        minimumAmount: one,
        maximumAmount: oneThousand,
        currencyCode: usdCode,
        locale: usLocale
      )
    )
  }

  func testValidConfigurationNoMinimum() {
    XCTAssertNoThrow(
      try Configuration(
        minimumAmount: nil,
        maximumAmount: oneThousand,
        currencyCode: usdCode,
        locale: usLocale
      )
    )
  }

  func testInvalidConfigurationInvalidCurrencyCode() {
    XCTAssertThrowsError(
      try Configuration(
        minimumAmount: one,
        maximumAmount: oneThousand,
        currencyCode: invalidCode,
        locale: usLocale
      )
    ) { error in
      XCTAssertEqual(error as? ConfigurationError, .invalidCurrencyCode(invalidCode))
    }
  }

  func testInvalidConfigurationInvalidMinimumWithAlphanumerics() {
    XCTAssertThrowsError(
      try Configuration(
        minimumAmount: invalidAlphaAmount,
        maximumAmount: oneThousand,
        currencyCode: usdCode,
        locale: usLocale
      )
    ) { error in
      XCTAssertEqual(error as? ConfigurationError, .invalidMinimum(invalidAlphaAmount))
    }
  }

  func testInvalidConfigurationInvalidMinimumWithNegatives() {
    XCTAssertThrowsError(
      try Configuration(
        minimumAmount: negativeAmount,
        maximumAmount: oneThousand,
        currencyCode: usdCode,
        locale: usLocale
      )
    ) { error in
      XCTAssertEqual(error as? ConfigurationError, .invalidMinimum(negativeAmount))
    }
  }

  func testInvalidConfigurationInvalidMaximumWithAlphanumerics() {
    XCTAssertThrowsError(
      try Configuration(
        minimumAmount: one,
        maximumAmount: invalidAlphaAmount,
        currencyCode: usdCode,
        locale: usLocale
      )
    ) { error in
      XCTAssertEqual(error as? ConfigurationError, .invalidMaximum(invalidAlphaAmount))
    }
  }

  func testInvalidConfigurationInvalidMaximumWithNegatives() {
    XCTAssertThrowsError(
      try Configuration(
        minimumAmount: one,
        maximumAmount: negativeAmount,
        currencyCode: usdCode,
        locale: usLocale
      )
    ) { error in
      XCTAssertEqual(error as? ConfigurationError, .invalidMaximum(negativeAmount))
    }
  }

  func testInvalidConfigurationInvalidMinimumMaximumOrdering() {
    XCTAssertThrowsError(
      try Configuration(
        minimumAmount: oneThousand,
        maximumAmount: one,
        currencyCode: usdCode,
        locale: usLocale
      )
    ) { error in
      XCTAssertEqual(
        error as? ConfigurationError,
        .invalidOrdering(minimum: oneThousand, maximum: one)
      )
    }
  }

}
