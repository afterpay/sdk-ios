//
//  PaymentDetails.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 12/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

struct PaymentDetails: Decodable {
  let virtualCard: VirtualCard
}

public struct VirtualCard: Decodable, Equatable {
  let cardType: String
  let cardNumber: String
  let cvc: String
  let expiry: String

  static func empty() -> Self {
    return VirtualCard(cardType: "", cardNumber: "", cvc: "", expiry: "")
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.cardNumber == rhs.cardNumber
  }
}
