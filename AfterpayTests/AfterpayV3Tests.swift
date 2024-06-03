//
//  AfterpayV3Tests.swift
//  AfterpayTests
//
//  Created by Mark Mroz on 2024-06-03.
//  Copyright © 2024 Afterpay. All rights reserved.
//

import XCTest
@testable import Afterpay

final class AfterpayV3Tests: XCTestCase {

  private var v3Configuration: CheckoutV3Configuration!

  override func setUpWithError() throws {
    try super.setUpWithError()
    v3Configuration = CheckoutV3Configuration(
      shopDirectoryMerchantId: "merchant_id",
      region: .US,
      environment: .production
    )

    let v2Configuration = try Configuration(
      minimumAmount: nil,
      maximumAmount: "150",
      currencyCode: "USD",
      locale: Locale(identifier: "en_US"),
      environment: .production
    )
    Afterpay.setConfiguration(v2Configuration)
  }

  override func tearDown() {
    v3Configuration = nil
    Afterpay.setConfiguration(nil)
    super.tearDown()
  }

  func testCheckoutV3WithCashAppPay() throws {
    let checkoutV3Expectation = self.expectation(description: "Checkout V3")
    let checkoutHandler: URLRequestHandler = { (request, response) in
      URLSessionMock(dataTaskHandler: { url in
        XCTAssertEqual(url.absoluteString, "https://api-plus.us.afterpay.com/v3/button")
        return (Fixtures.checkoutV3WithCashAppPayResponse, nil, nil)
      }).dataTask(with: request.url!) { data, urlResponse, error in
        checkoutV3Expectation.fulfill()
        response(data, urlResponse, error)
      }
    }

    let signTokenExpectation = self.expectation(description: "Sign Token")
    let signHandler = URLSessionMock(requestDataTaskHandler: { request in
      XCTAssertEqual(request.url?.absoluteString, "https://api-plus.us.afterpay.com/v2/payments/sign-payment")
      signTokenExpectation.fulfill()
      return (Fixtures.signPaymentResponse, HTTPURLResponse(), nil)
    })

    let checkoutExpectation = self.expectation(description: "Completed Checkout")
    Afterpay.checkoutV3WithCashAppPay(
      consumer: Consumer(email: "jack@xyz.com"),
      orderTotal: OrderTotal(total: 10, shipping: 0, tax: 0),
      items: [Product(name: "Coffee", quantity: 1, price: 10)],
      configuration: v3Configuration,
      urlSession: signHandler,
      requestHandler: checkoutHandler
    ) { result in
      switch result {
      case .success(let data):
        XCTAssertEqual(data.singleUseCardToken, "AQI")
        XCTAssertEqual(data.token, "002.x")
        XCTAssertEqual(data.cashAppSigningData.amount, 5000)
        XCTAssertEqual(data.cashAppSigningData.brandId, "BRAND_ID")
        XCTAssertEqual(data.cashAppSigningData.merchantId, "MMI_6nvgu9voweagwt5dn0kdteaio")
        XCTAssertEqual(
          data.cashAppSigningData.redirectUri.absoluteString,
          "https://static-us.afterpay.com/javascript/button/index.html"
        )
      case .cancelled, .failure:
        XCTFail("Expected success")
      }
      checkoutExpectation.fulfill()
    }
    waitForExpectations(timeout: 0.5)
  }

  func testCheckoutV3ConfirmForCashAppPay() {

    let confirmRequestExpectation = self.expectation(description: "Confirmed")
    let checkoutHandler: URLRequestHandler = { (request, response) in
      URLSessionMock(dataTaskHandler: { url in
        XCTAssertEqual(url.absoluteString, "https://api-plus.us.afterpay.com/v3/button/confirm")
        return (Fixtures.confirmResponse, nil, nil)
      }).dataTask(with: request.url!) { data, urlResponse, error in
        confirmRequestExpectation.fulfill()
        response(data, urlResponse, error)
      }
    }

    let confirmExpectation = self.expectation(description: "Confirmed")
    Afterpay.checkoutV3ConfirmForCashAppPay(
      token: "002.x",
      singleUseCardToken: "AQI",
      cashAppPayCustomerID: "CUST_ID",
      cashAppPayGrantID: "GRR_ID",
      jwt: "JWT",
      configuration: v3Configuration,
      requestHandler: checkoutHandler
    ) { result in
      switch result {
      case .success(let data):
        XCTAssertEqual(data.paymentDetails.virtualCard?.cardType, "VISA")
        XCTAssertEqual(data.paymentDetails.virtualCard?.cardNumber, "4111111111111111")
        XCTAssertEqual(data.paymentDetails.virtualCard?.cvc, "737")
        XCTAssertEqual(data.paymentDetails.virtualCard?.expiryMonth, 3)
        XCTAssertEqual(data.paymentDetails.virtualCard?.expiryYear, 30)
        XCTAssertNotNil(data.cardValidUntil)
      case .failure:
        XCTFail("Expected success")
      }

      confirmExpectation.fulfill()
    }

    waitForExpectations(timeout: 0.5)
  }
}

// MARK: - Private

private extension AfterpayV3Tests {
  struct Product: CheckoutV3Item {
    let name: String
    let quantity: UInt
    let price: Decimal
    let sku: String? = nil
    let pageUrl: URL? = nil
    let imageUrl: URL? = nil
    let categories: [[String]]? = nil
    let estimatedShipmentDate: String? = nil
  }
}

// MARK: - Fixtures

extension AfterpayV3Tests {
  // swiftlint:disable line_length indentation_width
  enum Fixtures {
    static let checkoutV3WithCashAppPayResponse = """
    {
        "token":  "002.x",
        "confirmMustBeCalledBefore": "2024-06-04T02:29:53.803Z",
        "redirectCheckoutUrl": "https://portal.sandbox.afterpay.com/us/checkout/?token=002.x",
        "singleUseCardToken": "AQI"
    }
    """.data(using: .utf8)

    static let signPaymentResponse = """
    {
        "jwtToken":  "eyJraWQiOiJrZXkxIiwiYWxnIjoiRVMyNTYiLCJ0dGwiOiIxNzE3NDM3Nzc1In0.eyJleHRlcm5hbE1lcmNoYW50SWQiOiJNTUlfNm52Z3U5dm93ZWFnd3Q1ZG4wa2R0ZWFpbyIsInRva2VuIjoiMDAyLmlscXFqZjJ1ZG11MnJwM3hjdTdjYjZtenVwNnRlZndiM2Q1eWs2Y3pyZnZqd3Nmb2NuIiwiYW1vdW50Ijp7ImFtb3VudCI6IjUwLjAwIiwiY3VycmVuY3kiOiJVU0QiLCJzeW1ib2wiOiIkIn0sInJlZGlyZWN0VXJsIjoiaHR0cHM6Ly9zdGF0aWMtdXMuYWZ0ZXJwYXkuY29tL2phdmFzY3JpcHQvYnV0dG9uL2luZGV4Lmh0bWwifQ.KRVxIHwrH_QPDTX2WF3Ei5wI7InE_v7xvPDDXFF2YBka2hUROkSX6ubdrFufIkE6yaFHyrlAGoQiS17VB80IDA",
        "redirectUrl":  "https://static-us.afterpay.com",
        "externalBrandId":  "BRAND_ID"
    }
    """.data(using: .utf8)

    static let confirmResponse = """
    {
        "paymentDetails": {
            "virtualCard":  {
                "cardType":  "VISA",
                "cardNumber":  "4111111111111111",
                "cvc":  "737",
                "expiry":  "30-03"
            }
        },
        "cardValidUntil": "2024-06-03T18:31:32.096071575Z"
    }
    """.data(using: .utf8)
  }
}
