//
//  CartDisplay.swift
//  Example
//
//  Created by Adam Campbell on 2/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Foundation

struct CartDisplay {

  let products: [ProductDisplay]
  let message: String?
  let total: Decimal
  let displayTotal: String
  let payEnabled: Bool
  let checkoutV2Options: CheckoutV2Options

  let expressCheckout: Bool

  init(
    products: [ProductDisplay],
    total: Decimal,
    currencyCode: String,
    expressCheckout: Bool,
    initialCheckoutOptions: CheckoutV2Options
  ) {
    self.products = products
    self.message = products.isEmpty ? "Please add some items to your cart." : nil
    self.payEnabled = products.isEmpty ? false : true

    self.total = total
    let formatter = CurrencyFormatter(currencyCode: currencyCode)
    self.displayTotal = formatter.displayString(from: total)
    self.expressCheckout = expressCheckout
    self.checkoutV2Options = initialCheckoutOptions
  }

}
