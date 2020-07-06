//
//  CartDisplay.swift
//  Example
//
//  Created by Adam Campbell on 2/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

struct CartDisplay {

  let products: [ProductDisplay]
  let message: String?
  let displayTotal: String
  let payEnabled: Bool

  init(products: [Product], quantities: [UUID: UInt], currencyCode: String) {
    let productsInCart = products.filter { quantities[$0.id].map({ $0 > 0 }) ?? false }

    self.message = productsInCart.isEmpty ? "Please add some items to your cart." : nil
    self.payEnabled = productsInCart.isEmpty ? false : true

    self.products = ProductDisplay
      .products(productsInCart, quantities: quantities, currencyCode: currencyCode)

    let total = productsInCart.reduce(into: Decimal.zero) { total, product in
      let quantity = quantities[product.id] ?? 0
      total += product.price * Decimal(quantity)
    }

    let formatter = CurrencyFormatter(currencyCode: currencyCode)
    displayTotal = formatter.string(from: total)
  }

}
