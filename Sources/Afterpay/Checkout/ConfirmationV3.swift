//
//  ConfirmationV3.swift
//  Afterpay
//
//  Created by Chris Kolbu on 12/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

// swiftlint:disable nesting
enum ConfirmationV3 {

  struct Request: Encodable {
    let token: String
    let singleUseCardToken: String
    let ppaConfirmToken: String
  }

  struct Response: Decodable {
    let paymentDetails: PaymentDetails
    let cardValidUntil: Date?
    let authToken: String

    struct PaymentDetails: Decodable {
      let virtualCard: Card?
      let virtualCardToken: TokenizedCard?
    }
  }

}
