//
//  ShippingOption.swift
//  Afterpay
//
//  Created by Adam Campbell on 7/12/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

public struct ShippingOption: Encodable {
  var id: String
  var name: String
  var description: String
  var shippingAmount: Money
  var orderAmount: Money
}

public struct Money: Encodable {
  var amount: String
  var currency: String
}
