//
//  Money.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 10/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public struct Money: Codable, Equatable {
  let amount: String
  let currency: String

  public init(amount: String, currency: String) {
    self.amount = amount
    self.currency = currency
  }

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.amount == rhs.amount && lhs.currency == lhs.currency
  }
}

public struct Discount: Codable {
  let displayName: String
  let amount: Money

  public init(displayName: String, amount: Money) {
    self.displayName = displayName
    self.amount = amount
  }
}
