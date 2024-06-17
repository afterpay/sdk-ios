//
//  CheckoutV3RequestTests.swift
//  AfterpayTests
//
//  Created by Mark Mroz on 2024-06-16.
//  Copyright © 2024 Afterpay. All rights reserved.
//

@testable import Afterpay
import XCTest

final class CheckoutV3RequestTests: XCTestCase {
  func testEncodingWithCashAppIncludesEncodedKey() throws {
    let customer = Customer(
      email: "jack@email.com",
      givenNames: nil,
      surname: nil,
      phoneNumber: nil,
      shippingInformation: nil,
      billingInformation: nil
    )
    let request = CheckoutV3.Request(
      consumer: customer,
      orderTotal: OrderTotal(total: 1, shipping: 1, tax: 0),
      items: [],
      isCashAppPay: true,
      configuration: CheckoutV3Configuration(shopDirectoryMerchantId: "", region: .US, environment: .production)
    )
    let encoded = try JSONEncoder().encode(request)
    let stringData = try XCTUnwrap(String(data: encoded, encoding: .utf8))
    XCTAssert(stringData.localizedCaseInsensitiveContains("isCashApp"))
  }

  func testEncodingWithoutCashAppDoesNotIncludeEncodedKey() throws {
    let customer = Customer(
      email: "jack@email.com",
      givenNames: nil,
      surname: nil,
      phoneNumber: nil,
      shippingInformation: nil,
      billingInformation: nil
    )
    
    let request = CheckoutV3.Request(
      consumer: customer,
      orderTotal: OrderTotal(total: 1, shipping: 1, tax: 0),
      items: [],
      isCashAppPay: false,
      configuration: CheckoutV3Configuration(shopDirectoryMerchantId: "", region: .US, environment: .production)
    )
    let encoded = try JSONEncoder().encode(request)
    let stringData = try XCTUnwrap(String(data: encoded, encoding: .utf8))
    XCTAssertFalse(stringData.localizedCaseInsensitiveContains("isCashApp"))
  }
}

private extension CheckoutV3RequestTests {
  struct Customer: CheckoutV3Consumer {
    let email: String
    let givenNames: String?
    let surname: String?
    let phoneNumber: String?
    let shippingInformation: CheckoutV3Contact?
    let billingInformation: CheckoutV3Contact?
  }

  struct Contact: CheckoutV3Contact {
    let name: String
    let line1: String
    let line2: String?
    let area1: String?
    let area2: String?
    let region: String?
    let postcode: String?
    let countryCode: String
    let phoneNumber: String?
  }
}
