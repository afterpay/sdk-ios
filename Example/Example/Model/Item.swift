//
//  Item.swift
//  Example
//
//  Created by Nabila Herzegovina on 18/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Afterpay
import Foundation

extension Item {
  static func createItems(
    with quantities: [UUID: UInt],
    products: [Product],
    currencyCode: String) -> [Item] {
    var items = [Item]()

    for (id, quantity) in quantities {
      guard let product = products.first(where: { $0.id == id }) else {
        continue
      }

      let price = NSDecimalNumber(decimal: product.price).stringValue

      let item = Item(
        name: product.name,
        quantity: quantity,
        pageUrl: URL(string: "https://www.apple.com")!,
        price: Money(amount: price, currency: currencyCode)
      )

      items.append(item)
    }

    return items
  }
}
