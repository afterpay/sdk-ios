//
//  APIPlusNetworkServiceTestScenario.swift
//  AfterpayTests
//
//  Created by Nabila Herzegovina on 3/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

@testable import Afterpay
import Foundation

enum APIPlusNetworkServiceTestScenario {
  case success
  case apiError
  case decodeError
}

extension SingleUseCardResponse {
  static func mock(scenario: APIPlusNetworkServiceTestScenario) -> Data {
    let jsonString: String

    switch scenario {
    case .success:
      jsonString =
      """
      {
        "consumerCardToken": "CC13851e16b3e24fb783f63d90bbed805c",
        "token": "002.cr7v4knfeh38209sd2iu0btqlc87nkfogregdntsom1ghlk2",
        "expires": "2021-03-03T07:31:53.553Z",
        "redirectCheckoutUrl": "https://www.apple.com"
      }
      """

    case .apiError:
      jsonString =
      """
      {
        "errorCode": "Precondition Failed",
        "errorId": "44b1f24a5f9e48f1bc53738341314143",
        "message": "Order 100101370360 is voided, expired or older than 25 days.",
        "httpStatusCode": 412
      }
      """

    case .decodeError :
      jsonString =
      """
      {
        "id": "sample_id"
      }
      """
    }

    return Data(jsonString.utf8)
  }
}

extension SingleUseCardConfirmRequest {
  static func mock() -> SingleUseCardConfirmRequest {
    return SingleUseCardConfirmRequest(
      consumerCardToken: "consumerCardToken1234",
      token: "token1234",
      requestId: "",
      aggregator: "merchantAggregator"
    )
  }
}

extension SingleUseCardRequest {
  static func mock() -> SingleUseCardRequest {
    let consumer = Consumer(
      phoneNumber: "",
      givenNames: "",
      surname: "",
      email: "john.smith@gmail.com"
    )

    return SingleUseCardRequest(
      aggregator: "",
      amount: Money(amount: "35.00", currency: "USD"),
      consumer: consumer,
      merchant: Merchant(name: "AfterSnack")
    )
  }
}
