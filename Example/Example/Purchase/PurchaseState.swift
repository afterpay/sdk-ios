//
//  PurchaseState.swift
//  Example
//
//  Created by Adam Campbell on 1/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

enum PurchaseState {
  case browsing(products: [ProductDisplay])

  static let initial: PurchaseState = .browsing(
    products: [
      Product(name: "Coffee", description: "Ground 250g", price: 12.99),
      Product(name: "Milk", description: "Full Cream 2L", price: 3.49),
      Product(name: "Drinking Chocolate", description: "Malted 460g", price: 7.00),
    ].map {
      ProductDisplay(product: $0, quantity: 0)
    }
  )
}
