// Copyright 2021 Itty Bitty Apps Pty Ltd

import XCTest
@testable import Afterpay

// swiftlint:disable indentation_width
final class VirtualCardDeserializationTests: XCTestCase {

  func testPlainCardIsDeserializedProperly() throws {
    let json = """
{
"cardType": "VISA",
"cardNumber": "4444444444444448",
"cvc": "999",
"expiry": "2024-02"
}
""".data(using: .utf8)!

    let model = try JSONDecoder().decode(VirtualCard.self, from: json)

    guard case .card = model else {
      XCTFail("Expected VirtualCard.card!")
      return
    }
  }

  func testTokenizedCardIsDeserializedProperly() throws {
    let json = """
{
"paymentGateway": "Braintree",
"cardToken": "magical string",
"expiry": "2024-02"
}
""".data(using: .utf8)!

    let model = try JSONDecoder().decode(VirtualCard.self, from: json)

    guard case .tokenized = model else {
      XCTFail("Expected VirtualCard.card!")
      return
    }
  }

  func testUnknownCardFailsWithProperDescription() throws {
    let json = """
{
"cardType": "VISA",
"cardWhatNow": "Didn't expect you here",
"cvc": "999",
"expiry": "2024-02"
}
""".data(using: .utf8)!

    do {
      _ = try JSONDecoder().decode(VirtualCard.self, from: json)
      XCTFail("Expected error to be thrown")
    } catch is VirtualCard.Error {
      // The correct error was thrown
    } catch {
      XCTFail("Expected a `VirtualCard.Error`")
    }
  }

}
