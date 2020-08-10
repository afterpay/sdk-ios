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

  func testNoConfiguration() {
    let breakdown = PriceBreakdown(totalAmount: .zero)

    XCTAssertEqual(breakdown.badgePlacement, .end)
    XCTAssertEqual(breakdown.string, "or pay with")
  }

}
