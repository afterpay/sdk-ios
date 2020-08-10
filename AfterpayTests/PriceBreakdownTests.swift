//
//  PriceBreakdownTests.swift
//  AfterpayTests
//
//  Created by Adam Campbell on 10/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

@testable import Afterpay
import XCTest

class PriceBreakdownTests: XCTestCase {

  override func tearDown() {
    Afterpay.setConfiguration(nil)
  }

  func testNoConfiguration() {
    let breakdown = PriceBreakdown(totalAmount: .zero)

    XCTAssertEqual(breakdown.badgePlacement, .end)
    XCTAssertEqual(breakdown.string, "or pay with")
  }

  func testInstalments() {
    let configuration = try? Configuration(
      minimumAmount: "50.00",
      maximumAmount: "200.00",
      currencyCode: "USD")

    configuration.map(Afterpay.setConfiguration)

    let breakdown = PriceBreakdown(totalAmount: 100)

    XCTAssertEqual(breakdown.badgePlacement, .end)
    XCTAssertEqual(breakdown.string, "or 4 instalments of $25.00 with")
  }

}
