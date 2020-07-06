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
  let displayTotal: String

  init(products: [Product], quantities: [UUID: UInt], currencyCode: String) {
    self.products = ProductDisplay
      .products(products, quantities: quantities, currencyCode: currencyCode, editable: false)

    let total = products.reduce(into: Decimal.zero) { total, product in
      let quantity = quantities[product.id] ?? 0
      total += product.price * Decimal(quantity)
    }

    let formatter = CurrencyFormatter(currencyCode: currencyCode)
    displayTotal = formatter.string(from: total)
  }

}
