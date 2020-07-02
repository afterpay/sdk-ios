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

  let id: UUID
  let title: String
  let subtitle: String
  let displayPrice: String
  let quantity: String
  let editable: Bool

  private static let formatter = NumberFormatter()

  init(product: Product, quantity: UInt, currencyCode: String, editable: Bool) {
    id = product.id
    title = product.name
    subtitle = product.description

    let formatter = Self.formatter
    formatter.currencyCode = currencyCode
    let localCurrencyCode = Locale.current.currencyCode
    formatter.numberStyle = localCurrencyCode == currencyCode ? .currency : .currencyISOCode
    displayPrice = formatter.string(from: product.price as NSDecimalNumber) ?? ""

    self.quantity = "\(quantity)"
    self.editable = editable
  }

}
