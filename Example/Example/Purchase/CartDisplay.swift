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
  let displayTotal: String
  let payEnabled: Bool
  let initialCheckoutOptions: CheckoutV2Options

  init(products: [ProductDisplay], total: Decimal, currencyCode: String, initialCheckoutOptions: CheckoutV2Options) {
    self.products = products
    self.message = products.isEmpty ? "Please add some items to your cart." : nil
    self.payEnabled = products.isEmpty ? false : true

    let formatter = CurrencyFormatter(currencyCode: currencyCode)
    self.displayTotal = formatter.displayString(from: total)
    self.initialCheckoutOptions = initialCheckoutOptions
  }

}
