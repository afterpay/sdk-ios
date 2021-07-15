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

  /// Amount to be charged to consumer, inclusive of `shipping` and `tax`.
  public var total: Decimal
  /// The shipping amount, included for fraud detection purposes.
  public var shipping: Decimal
  /// The tax amount, included for fraud detection purposes.
  public var tax: Decimal

  /// - Parameters:
  ///   - total: Amount to be charged to consumer, inclusive of `shipping` and `tax`.
  ///   - shipping: The shipping amount, included for fraud detection purposes.
  ///   - tax: The tax amount, included for fraud detection purposes.
  public init(total: Decimal, shipping: Decimal, tax: Decimal) {
    self.total = total
    self.shipping = shipping
    self.tax = tax
  }

}
