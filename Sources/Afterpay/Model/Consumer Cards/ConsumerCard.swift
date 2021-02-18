//
//  ConsumerCard.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 9/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public struct ConsumerCardRequest: Encodable {
  let aggregator: String
  var amount: Money
  let consumer: Consumer
  let billing: Contact?
  let shipping: Contact?
  let items: [Item]?
  let discounts: [Discount]?
  let merchant: Merchant
  let merchantReference: String?
  let taxAmount: Money?
  let shippingAmount: Money?

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
