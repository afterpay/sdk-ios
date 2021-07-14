//
//  Consumer.swift
//  Afterpay
//
//  Created by Chris Kolbu on 14/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public struct OrderTotal {

  public var shipping: Decimal
  public var tax: Decimal
  public var subtotal: Decimal

  public init(shipping: Decimal, tax: Decimal, subtotal: Decimal) {
    self.shipping = shipping
    self.tax = tax
    self.subtotal = subtotal
  }
}
