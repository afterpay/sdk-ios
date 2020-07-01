//
//  Product.swift
//  Example
//
//  Created by Adam Campbell on 1/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

struct Product {
  let id = UUID()
  let name: String
  let description: String
  let price: Decimal
}

struct ProductDisplay {
  let id: UUID
  let title: String
  let subtitle: String
  let displayPrice: String
  let quantity: String

  init(product: Product, quantity: UInt) {
    id = product.id
    title = product.name
    subtitle = product.description
    displayPrice = "\(product.price)"
    self.quantity = "\(quantity)"
  }
}
