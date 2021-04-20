//
//  WidgetStatusTests.swift
//  AfterpayTests
//
//  Created by Huw Rowlands on 13/4/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

@testable import Afterpay
import XCTest

final class WidgetStatusTests: XCTestCase {

  func testDecodingValid() throws {
    let validStatus = """
    {
      "isValid": true,
      "amountDueToday": { "amount": "30.00", "currency": "USD" },
      "paymentScheduleChecksum": "magicNumberHere"
    }
    """.data(using: .utf8)!

    let status = try JSONDecoder().decode(WidgetStatus.self, from: validStatus)

    XCTAssertEqual(
      status,
      .valid(amountDueToday: Money(amount: "30.00", currency: "USD"), checksum: "magicNumberHere")
    )
  }

  func testDecodingInvalid() throws {
    let validStatus = """
    {
      "isValid": false,
      "error": { "errorCode": "SAD", "message": "I am sad" }
    }
    """.data(using: .utf8)!

    let status = try JSONDecoder().decode(WidgetStatus.self, from: validStatus)

    XCTAssertEqual(
      status,
      .invalid(errorCode: "SAD", message: "I am sad")
    )
  }

}
