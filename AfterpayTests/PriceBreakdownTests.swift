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

  private let setMinumumMaximumConfiguration = {
    Afterpay.setConfiguration(
      try? Configuration(minimumAmount: "50.00", maximumAmount: "200.00", currencyCode: "USD")
    )
  }

  private let setMaximumConfiguration = {
    Afterpay.setConfiguration(
      try? Configuration(minimumAmount: nil, maximumAmount: "200.00", currencyCode: "USD")
    )
  }

  func testInstalments() {
    setMinumumMaximumConfiguration()

    let fiftyDollarBreakdown = PriceBreakdown(totalAmount: 50)
    XCTAssertEqual(fiftyDollarBreakdown.badgePlacement, .end)
    XCTAssertEqual(fiftyDollarBreakdown.string, "or 4 instalments of $12.50 with")

    let oneHundredDollarBreakdown = PriceBreakdown(totalAmount: 100)
    XCTAssertEqual(oneHundredDollarBreakdown.badgePlacement, .end)
    XCTAssertEqual(oneHundredDollarBreakdown.string, "or 4 instalments of $25.00 with")

    let twoHundredDollarBreakdown = PriceBreakdown(totalAmount: 200)
    XCTAssertEqual(twoHundredDollarBreakdown.badgePlacement, .end)
    XCTAssertEqual(twoHundredDollarBreakdown.string, "or 4 instalments of $50.00 with")
  }

  func testOutOfRangeWithMinimum() {
    setMinumumMaximumConfiguration()

    let outOfRangeBreakdowns = [
      PriceBreakdown(totalAmount: 0),
      PriceBreakdown(totalAmount: 25),
      PriceBreakdown(totalAmount: 49.99),
      PriceBreakdown(totalAmount: 200.01),
      PriceBreakdown(totalAmount: 300),
    ]

    for breakdown in outOfRangeBreakdowns {
      XCTAssertEqual(breakdown.badgePlacement, .start)
      XCTAssertEqual(breakdown.string, "is available between $50.00-$200.00")
    }
  }

  func testOutOfRangeWithNoMinimum() {
    setMaximumConfiguration()

    let outOfRangeBreakdowns = [
      PriceBreakdown(totalAmount: 0),
      PriceBreakdown(totalAmount: 200.01),
      PriceBreakdown(totalAmount: 300),
    ]

    for breakdown in outOfRangeBreakdowns {
      XCTAssertEqual(breakdown.badgePlacement, .start)
      XCTAssertEqual(breakdown.string, "is available under $200.00")
    }
  }

}
