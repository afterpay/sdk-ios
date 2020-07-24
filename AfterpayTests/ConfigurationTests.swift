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

  func testValidConfiguration() throws {
    _ = try Configuration(
      minimumAmount: "1.00",
      maximumAmount: "10.00",
      currencyCode: "USD")
  }

}
