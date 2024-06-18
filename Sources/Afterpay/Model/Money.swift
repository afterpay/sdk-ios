//
//  Money.swift
//  Afterpay
//
//  Created by Huw Rowlands on 6/4/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public struct Money: Codable, Equatable {
  /// The amount is a string representation of a decimal number, rounded to 2 decimal places
  public var amount: String
  /// The currency in ISO 4217 format. Supported values include "AUD", "NZD", "CAD", and "USD".
  /// However, the value provided must correspond to the currency of the Merchant account making the request.
  public var currency: String

  public init(amount: String, currency: String) {
    self.amount = amount
    self.currency = currency
  }

}
