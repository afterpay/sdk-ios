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
  public let cardType: String
  public let cardNumber: String
  public let cvc: String
  public let expiry: String

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.cardNumber == rhs.cardNumber
  }
}
