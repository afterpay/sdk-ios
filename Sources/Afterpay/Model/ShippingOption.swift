//
//  ShippingOption.swift
//  Afterpay
//
//  Created by Adam Campbell on 7/12/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

public struct ShippingOption: Codable {
  var id: String
  var name: String
  var description: String
  var shippingAmount: Money
  var orderAmount: Money
  var taxAmount: Money?

  public init(
    id: String,
    name: String,
    description: String,
    shippingAmount: Money,
    orderAmount: Money,
    taxAmount: Money? = nil
  ) {
    self.id = id
    self.name = name
    self.description = description
    self.shippingAmount = shippingAmount
    self.orderAmount = orderAmount
    self.taxAmount = taxAmount
  }
}

public struct Money: Codable {
  var amount: String
  var currency: String

  public init(amount: String, currency: String) {
    self.amount = amount
    self.currency = currency
  }
}
