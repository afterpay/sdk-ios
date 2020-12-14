//
//  ExpressCheckoutHandler.swift
//  Example
//
//  Created by Adam Campbell on 14/12/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Foundation

final class ExpressCheckoutHandler: Afterpay.ExpressCheckoutHandler {

  private var email: String = Settings.email
  private var amount: String = "0.00"

  func update(email: String, amount: String) {
    self.email = email
    self.amount = amount
  }

  func didCommenceCheckout(callback: @escaping (Result<URL, Error>) -> Void) {
    Repository.shared.checkout(email: email, amount: amount, completion: callback)
  }

  func shippingAddressDidChange(address: Address, callback: @escaping ([ShippingOption]) -> Void) {
    let standard = ShippingOption(
      id: "standard",
      name: "Standard",
      description: "3 - 5 days",
      shippingAmount: Money(amount: "0.00", currency: "AUD"),
      orderAmount: Money(amount: "50.00", currency: "AUD")
    )

    let priority = ShippingOption(
      id: "priority",
      name: "Priority",
      description: "Next business day",
      shippingAmount: Money(amount: "10.00", currency: "AUD"),
      orderAmount: Money(amount: "60.00", currency: "AUD")
    )

    callback([standard, priority])
  }

  func shippingOptionDidChange(shippingOption: ShippingOption) {}

}
