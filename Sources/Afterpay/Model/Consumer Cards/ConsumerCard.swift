//
//  ConsumerCard.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 9/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public struct ConsumerCardRequest: Encodable {
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

  // swiftlint:disable:next colon line_length
  public init(aggregator: String, amount: Money, consumer: Consumer, billing: Contact?, shipping: Contact?, items: [Item]?, discounts: [Discount]?, merchant: Merchant, merchantReference: String?, taxAmount: Money?, shippingAmount: Money?) {
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

public struct ConsumerCardResponse: Decodable {
  let consumerCardToken: String
  let token: String
  let expires: String
  public let redirectCheckoutUrl: URL
}
