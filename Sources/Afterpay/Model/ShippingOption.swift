//
//  ShippingOption.swift
//  Afterpay
//
//  Created by Adam Campbell on 7/12/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

public struct ShippingOption: Codable {

  public var id: String
  public var name: String
  public var description: String
  public var shippingAmount: Money
  public var orderAmount: Money
  public var taxAmount: Money?

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
