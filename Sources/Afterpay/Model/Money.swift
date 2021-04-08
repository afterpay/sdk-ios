//
//  Money.swift
//  Afterpay
//
//  Created by Huw Rowlands on 6/4/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public struct Money: Codable, Equatable {

  var amount: String
  var currency: String

  public init(amount: String, currency: String) {
    self.amount = amount
    self.currency = currency
  }

}
