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
    } catch {
      let expectedError = ConfigurationError.invalidCurrencyCode(invalidCode)
      XCTFail("Failed to match expected error \(expectedError)")
    }
  }

}
