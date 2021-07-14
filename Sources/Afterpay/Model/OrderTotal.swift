//
//  Consumer.swift
//  Afterpay
//
//  Created by Chris Kolbu on 14/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

/// The order total. Each property will be transformed to a `Money` object by
/// conforming the amount to ISO 4217 by:
/// - Rounding to 2 decimals using banker's rounding.
/// - Including the currency code as provided by `CheckoutV3Configuration.Region`.
public struct OrderTotal {

  public var subtotal: Decimal
  public var shipping: Decimal?
  public var tax: Decimal?

  public var total: Decimal {
    subtotal + (shipping ?? 0) + (tax ?? 0)
  }

  public init(subtotal: Decimal, shipping: Decimal? = nil, tax: Decimal? = nil) {
    self.subtotal = subtotal
    self.shipping = shipping
    self.tax = tax
  }

}
