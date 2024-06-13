//
//  CashAppPayTests.swift
//  AfterpayTests
//
//  Created by Mark Mroz on 2024-06-13.
//  Copyright © 2024 Afterpay. All rights reserved.
//

import XCTest
@testable import Afterpay

final class CashAppPayTests: XCTestCase {
  func testSignCashAppOrderToken() {
    let signingURL = "https://api-plus.us.afterpay.com/v2/payments/sign-payment"
    let signTokenExpectation = self.expectation(description: "Sign Token")
    let handle = URLSessionMock(requestDataTaskHandler: { request in
      XCTAssertEqual(request.url?.absoluteString, signingURL)

      return (Fixtures.signPaymentResponse, HTTPURLResponse(), nil)
    })

    CashAppPayCheckout.signCashAppOrderToken("Token", cashAppSigningURL: signingURL, urlSession: handle) { _ in
      signTokenExpectation.fulfill()
    }
    waitForExpectations(timeout: 0.5)
  }
}

// MARK: - Fixtures

extension CashAppPayTests {
  // swiftlint:disable line_length indentation_width
  enum Fixtures {
    static let signPaymentResponse = """
    {
        "jwtToken":  "eyJraWQiOiJrZXkxIiwiYWxnIjoiRVMyNTYiLCJ0dGwiOiIxNzE3NDM3Nzc1In0.eyJleHRlcm5hbE1lcmNoYW50SWQiOiJNTUlfNm52Z3U5dm93ZWFnd3Q1ZG4wa2R0ZWFpbyIsInRva2VuIjoiMDAyLmlscXFqZjJ1ZG11MnJwM3hjdTdjYjZtenVwNnRlZndiM2Q1eWs2Y3pyZnZqd3Nmb2NuIiwiYW1vdW50Ijp7ImFtb3VudCI6IjUwLjAwIiwiY3VycmVuY3kiOiJVU0QiLCJzeW1ib2wiOiIkIn0sInJlZGlyZWN0VXJsIjoiaHR0cHM6Ly9zdGF0aWMtdXMuYWZ0ZXJwYXkuY29tL2phdmFzY3JpcHQvYnV0dG9uL2luZGV4Lmh0bWwifQ.KRVxIHwrH_QPDTX2WF3Ei5wI7InE_v7xvPDDXFF2YBka2hUROkSX6ubdrFufIkE6yaFHyrlAGoQiS17VB80IDA",
        "redirectUrl":  "https://static-us.afterpay.com",
        "externalBrandId":  "BRAND_ID"
    }
    """.data(using: .utf8)
  }
}
