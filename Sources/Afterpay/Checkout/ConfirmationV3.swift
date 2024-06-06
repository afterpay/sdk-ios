//
//  ConfirmationV3.swift
//  Afterpay
//
//  Created by Chris Kolbu on 12/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

// swiftlint:disable nesting
public enum ConfirmationV3 {

  struct Request: Encodable {
    let token: String
    let singleUseCardToken: String
    let ppaConfirmToken: String
  }

  public struct Response: Decodable {
    let paymentDetails: PaymentDetails
    let cardValidUntil: Date?
    let authToken: String

    public struct PaymentDetails: Decodable {
      public let virtualCard: Card?
      public let virtualCardToken: TokenizedCard?
    }
  }

}
