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

  func testValidConfiguration() throws {
    _ = try Configuration(minimumAmount: one, maximumAmount: oneThousand, currencyCode: usdCode)
  }

  func testValidConfigurationNoMinimum() throws {
    _ = try Configuration(minimumAmount: nil, maximumAmount: oneThousand, currencyCode: usdCode)
  }

  func testInvalidConfigurationInvalidCurrencyCode() {
    do {
      _ = try Configuration(
        minimumAmount: one,
        maximumAmount: oneThousand,
        currencyCode: invalidCode)
    } catch ConfigurationError.invalidCurrencyCode(invalidCode) {
      return
    } catch {}

    failedToMatch(expectedError: ConfigurationError.invalidCurrencyCode(invalidCode))
  }

  func testInvalidConfigurationInvalidMinimumWithAlphanumerics() {
    do {
      _ = try Configuration(
        minimumAmount: invalidAlphaAmount,
        maximumAmount: oneThousand,
        currencyCode: usdCode)
    } catch ConfigurationError.invalidMinimum(invalidAlphaAmount) {
      return
    } catch {}

    failedToMatch(expectedError: ConfigurationError.invalidMinimum(invalidAlphaAmount))
  }

  func testInvalidConfigurationInvalidMinimumWithNegatives() {
    do {
      _ = try Configuration(
        minimumAmount: negativeAmount,
        maximumAmount: oneThousand,
        currencyCode: usdCode)
    } catch ConfigurationError.invalidMinimum(negativeAmount) {
      return
    } catch {}

    failedToMatch(expectedError: ConfigurationError.invalidMinimum(negativeAmount))
  }

  func testInvalidConfigurationInvalidMaximumWithAlphanumerics() {
    do {
      _ = try Configuration(
        minimumAmount: one,
        maximumAmount: invalidAlphaAmount,
        currencyCode: usdCode)
    } catch ConfigurationError.invalidMaximum(invalidAlphaAmount) {
      return
    } catch {}

    failedToMatch(expectedError: ConfigurationError.invalidMaximum(invalidAlphaAmount))
  }

  func testInvalidConfigurationInvalidMaximumWithNegatives() {
    do {
      _ = try Configuration(
        minimumAmount: one,
        maximumAmount: negativeAmount,
        currencyCode: usdCode)
    } catch ConfigurationError.invalidMaximum(negativeAmount) {
      return
    } catch {}

    failedToMatch(expectedError: ConfigurationError.invalidMaximum(negativeAmount))
  }

  func failedToMatch(expectedError: Error) {
    XCTFail("Failed to match expected error \(expectedError)")
  }

}
