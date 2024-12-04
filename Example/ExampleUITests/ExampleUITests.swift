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
    app.launchArguments.append(contentsOf: ["-com.afterpay.mock-widget-bootstrap", "YES"])
    app.launchArguments.append("-disableAnimations")

    app.launch()

    UIView.setAnimationsEnabled(false)
  }

  func testCheckoutShows() throws {
    app.staticTexts["+"].firstMatch.tap()

    app.staticTexts["View Cart"].tap()

    XCTAssertTrue(app.buttons["payNow"].waitForExistence(timeout: 0.5))
    app.buttons["payNow"].tap()

    // we assert _some_ type of web view is shown
    XCTAssertTrue(app.webViews.firstMatch.waitForExistence(timeout: 2))

    app.swipeDown()

    XCTAssertTrue(app.staticTexts["Are you sure you want to cancel the payment?"].waitForExistence(timeout: 3))

    app.buttons["Yes"].tap()
  }
}
