//
//  SingleUseCard.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 9/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public struct SingleUseCardRequest: Encodable {
  public let aggregator: String
  public var amount: Money
  public let consumer: Consumer
  public let billing: Contact?
  public let shipping: Contact?
  public let items: [Item]?
  public let discounts: [Discount]?
  public let merchant: Merchant
  public let merchantReference: String?
  public let taxAmount: Money?
  public let shippingAmount: Money?

  public init(
    aggregator: String,
    amount: Money,
    consumer: Consumer,
    billing: Contact? = nil,
    shipping: Contact? = nil,
    items: [Item]? = nil,
    discounts: [Discount]? = nil,
    merchant: Merchant,
    merchantReference: String? = nil,
    taxAmount: Money? = nil,
    shippingAmount: Money? = nil
  ) {
    self.aggregator = aggregator
    self.amount = amount
    self.consumer = consumer
    self.billing = billing
    self.shipping = shipping
    self.items = items
    self.discounts = discounts
    self.merchant = merchant
    self.merchantReference = merchantReference
    self.taxAmount = taxAmount
    self.shippingAmount = shippingAmount
  }
}

public struct SingleUseCardResponse: Decodable, Equatable {
  let consumerCardToken: String
  let token: String
  let expires: String
  public let redirectCheckoutUrl: URL
}
