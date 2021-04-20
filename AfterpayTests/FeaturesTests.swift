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
    XCTAssertFalse(AfterpayFeatures.testFeature)

    UserDefaults.standard.setVolatileDomain(["com.afterpay.test-feature": true], forName: UserDefaults.argumentDomain)

    XCTAssertTrue(AfterpayFeatures.testFeature)
  }

}

private extension AfterpayFeatures {

  /// A test feature
  ///
  /// This doesn't exist in real life, but it is here as an example of how we can read launch arguments and use them as
  /// flags. Usually, these will be defined in `AfterpayFeatures.swift`.
  static var testFeature: Bool {
    UserDefaults.standard.bool(forKey: "com.afterpay.test-feature")
  }

}
