//
//  ExampleUITests.swift
//  ExampleUITests
//
//  Created by Huw Rowlands on 30/4/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Afterpay
import XCTest

final class ExampleUITests: XCTestCase {

  private let app = XCUIApplication()

  override func setUp() {
    app.launchArguments = ["-com.afterpay.mock-widget-bootstrap", "YES"]
    app.launch()
  }

  func testCheckoutShows() throws {
    app.staticTexts["+"].firstMatch.tap()

    app.staticTexts["View Cart"].tap()

    XCTAssertTrue(app.buttons["payNow"].waitForExistence(timeout: 0.5))
    app.buttons["payNow"].tap()

    // we assert _some_ type of web view is shown
    XCTAssertTrue(app.webViews.firstMatch.waitForExistence(timeout: 2))

    app.swipeDown()

    XCTAssertTrue(app.staticTexts["Are you sure you want to cancel the payment?"].waitForExistence(timeout: 0.5))

    app.buttons["Yes"].tap()
  }

  func testTokenlessWidgetAppears() throws {
    app.buttons["Tokenless…"].tap()

    _ = app.webViews.staticTexts.firstMatch.waitForExistence(timeout: 10)

    let webViewText = app.webViews.staticTexts.firstMatch

    XCTAssertTrue(webViewText.label.contains(#"token":null"#))
    XCTAssertTrue(webViewText.label.contains(#"amount":"200.00"#))
    XCTAssertTrue(webViewText.label.contains(#"currency":"AUD"#))

    let textField = app.textFields.firstMatch
    textField.tap()
    textField.typeText("444")
    app.buttons["Update"].tap()

    XCTAssertTrue(webViewText.label.contains(#"{"amount":"444","currency":"AUD"}"#))
  }

}
