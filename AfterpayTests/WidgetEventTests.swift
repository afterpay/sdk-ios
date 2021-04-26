//
//  WidgetEventTests.swift
//  AfterpayTests
//
//  Created by Huw Rowlands on 13/4/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

@testable import Afterpay
import XCTest

final class WidgetEventTests: XCTestCase {

  private let fiftyBucks = Money(amount: "50.00", currency: "USD")

  func testDecodingReady() throws {
    let eventJSON = """
    {
      "type": "ready",
      "isValid": true,
      "amountDueToday": { "amount": "50.00", "currency": "USD" },
      "paymentScheduleChecksum": "123abc"
    }
    """.data(using: .utf8)!

    let event = try JSONDecoder().decode(WidgetEvent.self, from: eventJSON)

    XCTAssertEqual(
      event,
      .ready(isValid: true, amountDue: fiftyBucks, checksum: "123abc")
    )
  }

  func testDecodingChangeToValid() throws {
    let eventJSON = """
    {
      "type": "change",
      "isValid": true,
      "amountDueToday": { "amount": "50.00", "currency": "USD" },
      "paymentScheduleChecksum": "123abc"
    }
    """.data(using: .utf8)!

    let event = try JSONDecoder().decode(WidgetEvent.self, from: eventJSON)

    XCTAssertEqual(
      event,
      .change(status: .valid(amountDueToday: fiftyBucks, checksum: "123abc"))
    )
  }

  func testDecodingChangeToInvalid() throws {
    let eventJSON = """
    {
      "type": "change",
      "isValid": false,
      "error": { "errorCode": "SAD", "message": "I am sad" }
    }
    """.data(using: .utf8)!

    let event = try JSONDecoder().decode(WidgetEvent.self, from: eventJSON)

    XCTAssertEqual(
      event,
      .change(status: .invalid(errorCode: "SAD", message: "I am sad"))
    )
  }

  func testDecodingResize() throws {
    let eventJSON = """
    {
      "type": "resize",
      "size": 1337
    }
    """.data(using: .utf8)!

    let event = try JSONDecoder().decode(WidgetEvent.self, from: eventJSON)

    XCTAssertEqual(
      event,
      .resize(suggestedSize: 1337)
    )
  }

  func testDecodingError() throws {
    let eventJSON = """
    {
      "type": "error",
      "error": { "errorCode": "SAD", "message": "I am sad" }
    }
    """.data(using: .utf8)!

    let event = try JSONDecoder().decode(WidgetEvent.self, from: eventJSON)

    XCTAssertEqual(
      event,
      .error(errorCode: "SAD", message: "I am sad")
    )
  }

}
