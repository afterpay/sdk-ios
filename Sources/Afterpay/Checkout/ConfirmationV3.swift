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
      let virtualCard: VirtualCard
    }

    struct VirtualCard: Decodable, CheckoutV3VirtualCard {
      let cardNumber: String
      let cvc: String
      let expiryMonth: Int
      let expiryYear: Int

      // swiftlint:disable:next nesting
      private enum CodingKeys: String, CodingKey {
        case cardNumber, cvc, expiry
      }

      init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let expiryString = try container.decode(String.self, forKey: .expiry).split(separator: "-")

        guard expiryString.count == 2 else {
          throw DecodingError.dataCorruptedError(
            forKey: .expiry,
            in: container,
            debugDescription: "Expiry string wrong format Expected `-` as separator"
          )
        }

        guard
          let yearString = expiryString.first,
          let year = Int(yearString),
          let monthString = expiryString.last,
          let month = Int(monthString)
        else {
          throw DecodingError.dataCorruptedError(
            forKey: .expiry,
            in: container,
            debugDescription: "Expiry string wrong format Expected two integral values representing year and month"
          )
        }

        self.expiryYear = year
        self.expiryMonth = month
        self.cardNumber = try container.decode(String.self, forKey: .cardNumber)
        self.cvc = try container.decode(String.self, forKey: .cvc)
      }
    }
  }

}
