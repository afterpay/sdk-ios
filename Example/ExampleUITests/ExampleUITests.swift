//
//  ExampleUITests.swift
//  ExampleUITests
//
//  Created by Huw Rowlands on 30/4/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import XCTest

final class ExampleUITests: XCTestCase {

  private let app = XCUIApplication()

  override func setUp() {
    app.launchArguments = ["-com.afterpay.widget-enabled", "YES"]
    app.launch()
  }

  func testExampleAppLaunches() throws {
    app.staticTexts["+"].firstMatch.tap()

    app.staticTexts["View Cart"].tap()

    XCTAssertTrue(app.buttons["payNow"].waitForExistence(timeout: 0.5))
    app.buttons["payNow"].tap()

    XCTAssertTrue(app.buttons["Log In"].waitForExistence(timeout: 10)) /* big timeout because it takes ages to load */

    app.swipeDown()

    XCTAssertTrue(app.staticTexts["Are you sure you want to cancel the payment?"].waitForExistence(timeout: 0.5))

    app.buttons["Yes"].tap()
  }

  func testTokenlessWidget() throws {
    app.buttons["Tokenless…"].tap()

    XCTAssertTrue(app.staticTexts["Due today"].waitForExistence(timeout: 10))
    XCTAssertTrue(app.staticTexts["Today"].waitForExistence(timeout: 0.5))
    XCTAssertTrue(app.staticTexts["In 2 weeks"].waitForExistence(timeout: 0.5))
    XCTAssertTrue(app.staticTexts["In 4 weeks"].waitForExistence(timeout: 0.5))
  }

}
