//
//  SingleUseCard.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 11/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

// MARK: - Request Body

public struct SingleUseCardCreateRequest: Encodable {
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

protocol SingleUseCardRequest: Encodable {
  var consumerCardToken: String { get }
  var token: String { get }
  var aggregator: String { get }
}

struct SingleUseCardConfirmRequest: SingleUseCardRequest {
  var consumerCardToken: String
  var token: String
  var aggregator: String
}

struct SingleUseCardCancelRequest: SingleUseCardRequest {
  var consumerCardToken: String
  var token: String
  var aggregator: String
}

// MARK: - Response Body

public struct SingleUseCardCreateResponse: Decodable, Equatable {
  let consumerCardToken: String
  let token: String
  let expires: String
  public let redirectCheckoutUrl: URL
}

struct SingleUseCardConfirmResponse: Decodable {
  let id: String
  let token: String
  let paymentDetails: PaymentDetails
  let status: String
  let created: String
  let vccExpiry: String
  let originalAmount: Money
  let orderDetails: OrderDetails
}
