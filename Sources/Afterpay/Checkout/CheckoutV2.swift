//
//  CheckoutV2.swift
//  Afterpay
//
//  Created by Adam Campbell on 17/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

struct CheckoutV2: Encodable {
  var token: String
  var locale: String
  var environment: String
  var version: String

  var pickup: Bool?
  var buyNow: Bool?
  var shippingOptionRequired: Bool?

  init(token: Token, configuration: Configuration, options: CheckoutV2Options) {
    self.token = token
    self.locale = configuration.locale.identifier
    self.environment = configuration.environment.rawValue
    self.version = Version.sdkVersion
    self.pickup = options.pickup
    self.buyNow = options.buyNow
    self.shippingOptionRequired = options.shippingOptionRequired
  }
}
