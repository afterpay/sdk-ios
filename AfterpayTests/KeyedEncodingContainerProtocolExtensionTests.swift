//
//  KeyedEncodingContainerProtocolExtensionTests.swift
//  AfterpayTests
//
//  Created by Mark Mroz on 2024-06-16.
//  Copyright © 2024 Afterpay. All rights reserved.
//

@testable import Afterpay
import XCTest

final class KeyedEncodingContainerProtocolTests: XCTestCase {
  func testEncodeIfTrue() throws {
    let encoder = JSONEncoder()

    let params = Params(buyNow: true)
    let data = try encoder.encode(params)
    let paramsString = String(data: data, encoding: .utf8)
    XCTAssertEqual(paramsString, "{\"buyNow\":true}")
  }

  func testDoesNotEncodeIfFalse() throws {
    let encoder = JSONEncoder()

    let params = Params(buyNow: false)
    let data = try encoder.encode(params)
    let paramsString = String(data: data, encoding: .utf8)
    XCTAssertEqual(paramsString, "{}")
  }
}

private extension KeyedEncodingContainerProtocolTests {
  // swiftlint:disable nesting
  struct Params: Encodable {
    let buyNow: Bool

    enum CodingKeys: CodingKey {
      case buyNow
    }

    func encode(to encoder: any Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encodeIfTrue(self.buyNow, forKey: .buyNow)
    }
  }
}
