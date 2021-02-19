//
//  ConsumerCardConfirm.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 11/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

struct ConsumerCardConfirmRequest: Encodable {
  let consumerCardToken: String
  let token: String
  let requestId: String
  let aggregator: String
}

struct ConsumerCardConfirmResponse: Decodable {
  let id: String
  let token: String
  let paymentDetails: PaymentDetails
  let status: String
  let created: String
  let vccExpiry: String
  let originalAmount: Money
  let orderDetails: OrderDetails
}
