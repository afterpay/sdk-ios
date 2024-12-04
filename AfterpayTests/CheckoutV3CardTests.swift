//
//  CheckoutV3CardTests.swift
//  Afterpay
//
//  Created by Mark Mroz on 2024-12-04.
//  Copyright © 2024 Afterpay. All rights reserved.
//

import XCTest
@testable import Afterpay

final class CheckoutV3CardTests: XCTestCase {
  func testCardZeroPaddedExpiryMonth() {
    XCTAssertEqual(makeCard(expiryMonth: 1).zeroPaddedExpiryMonth, "01")
    XCTAssertEqual(makeCard(expiryMonth: 2).zeroPaddedExpiryMonth, "02")
    XCTAssertEqual(makeCard(expiryMonth: 3).zeroPaddedExpiryMonth, "03")
    XCTAssertEqual(makeCard(expiryMonth: 4).zeroPaddedExpiryMonth, "04")
    XCTAssertEqual(makeCard(expiryMonth: 5).zeroPaddedExpiryMonth, "05")
    XCTAssertEqual(makeCard(expiryMonth: 6).zeroPaddedExpiryMonth, "06")
    XCTAssertEqual(makeCard(expiryMonth: 7).zeroPaddedExpiryMonth, "07")
    XCTAssertEqual(makeCard(expiryMonth: 8).zeroPaddedExpiryMonth, "08")
    XCTAssertEqual(makeCard(expiryMonth: 9).zeroPaddedExpiryMonth, "09")
    XCTAssertEqual(makeCard(expiryMonth: 10).zeroPaddedExpiryMonth, "10")
    XCTAssertEqual(makeCard(expiryMonth: 11).zeroPaddedExpiryMonth, "11")
    XCTAssertEqual(makeCard(expiryMonth: 12).zeroPaddedExpiryMonth, "12")
  }

  // MARK: - Private

  private func makeCard(expiryMonth: Int) -> Card {
    Card(cardType: "Visa", cardNumber: "4242 4242 4242 4242", cvc: "222", expiryMonth: expiryMonth, expiryYear: 2024)
  }
}
