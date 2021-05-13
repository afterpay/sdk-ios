//
//  FeaturesTests.swift
//  AfterpayTests
//
//  Created by Huw Rowlands on 11/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

@testable import Afterpay
import XCTest

class FeaturesTests: XCTestCase {

  func testWidgetEnabledIsOffByDefault() {
    XCTAssertFalse(AfterpayFeatures.widgetEnabled)

    UserDefaults.standard.setVolatileDomain(["com.afterpay.widget-enabled": true], forName: UserDefaults.argumentDomain)

    XCTAssertTrue(AfterpayFeatures.widgetEnabled)
  }

}
