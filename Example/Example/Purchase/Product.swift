//
//  Product.swift
//  Example
//
//  Created by Adam Campbell on 1/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Foundation

struct Product {
  let id = UUID()
  let name: String
  let description: String
  let price: Decimal
}

extension Collection where Element == Product {
  static var stub: [Product] {
    [
      Product(
        name: "Coffee",
        description: "Ground 250g",
        price: Decimal(string: "12.99")!
      ),
      Product(
        name: "Milk",
        description: "Full Cream 2L",
        price: Decimal(string: "3.49")!
      ),
      Product(
        name: "Drinking Chocolate",
        description: "Malted 460g",
        price: Decimal(string: "7.00")!
      ),
    ]
  }
}

struct ProductDisplay {
  private let product: Product
  let quantity: UInt
  let id: UUID
  let title: String
  let subtitle: String
  let displayPrice: String
  let displayQuantity: String

  init(product: Product, quantity: UInt, currencyCode: String) {
    self.product = product
    self.quantity = quantity
    id = product.id
    title = product.name
    subtitle = product.description

    let formatter = CurrencyFormatter(currencyCode: currencyCode)
    displayPrice = formatter.displayString(from: product.price)

    self.displayQuantity = "\(quantity)"
  }

  static func products(
    _ products: [Product],
    quantities: [UUID: UInt],
    currencyCode: String
  ) -> [ProductDisplay] {
    products.map {
      ProductDisplay(
        product: $0,
        quantity: quantities[$0.id] ?? 0,
        currencyCode: currencyCode
      )
    }
  }

}

extension ProductDisplay: CheckoutV3Item {
  var name: String { title }
  var price: Decimal { product.price }
  var sku: String? { id.uuidString }
  var pageUrl: URL? { nil }
  var imageUrl: URL? { nil }
  var categories: [[String]]? { nil }
  var estimatedShipmentDate: String? { nil }
}
