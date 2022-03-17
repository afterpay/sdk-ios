//
//  ShippingOptionUpdate.swift
//  Afterpay
//
//  Created by Scott Antonac on 15/11/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public struct ShippingOptionUpdate: Codable {

  public var id: String
  public var shippingAmount: Money
  public var orderAmount: Money
  public var taxAmount: Money?

  public init(
    id: String,
    shippingAmount: Money,
    orderAmount: Money,
    taxAmount: Money? = nil
  ) {
    self.id = id
    self.shippingAmount = shippingAmount
    self.orderAmount = orderAmount
    self.taxAmount = taxAmount
  }

}
