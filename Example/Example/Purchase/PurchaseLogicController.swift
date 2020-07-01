//
//  PurchaseLogicController.swift
//  Example
//
//  Created by Adam Campbell on 1/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

final class PurchaseLogicController {

  typealias CheckoutURLProvider = (
    _ email: String,
    _ completion: @escaping (Result<URL, Error>) -> Void
  ) -> Void

  typealias PurchaseStateHandler = (PurchaseState) -> Void

  private enum Screen {
    case products
  }

  private let checkoutURLProvider: CheckoutURLProvider
  private let products: [Product] = .stub

  var stateHandler: PurchaseStateHandler = { _ in } {
    didSet { stateHandler(purchaseState) }
  }

  private var screen: Screen = .products

  private var productQuantities: [UUID: UInt] {
    didSet { stateHandler(purchaseState) }
  }

  private var purchaseState: PurchaseState {
    switch screen {
    case .products:
      let products = self.products.map {
        ProductDisplay(product: $0, quantity: productQuantities[$0.id] ?? 0)
      }
      return .browsing(products: products)
    }
  }

  init(checkoutURLProvider: @escaping CheckoutURLProvider) {
    self.checkoutURLProvider = checkoutURLProvider
    self.productQuantities = products.reduce(into: [UUID: UInt](), { quantities, product in
      quantities[product.id] = 0
    })
  }

  func incrementQuantityOfProduct(with id: UUID) {
    let quantity = productQuantities[id] ?? 0
    productQuantities[id] = quantity == .max ? .max : quantity + 1
  }

  func decrementQuantityOfProduct(with id: UUID) {
    let quantity = productQuantities[id] ?? 0
    productQuantities[id] = quantity == 0 ? 0 : quantity - 1
  }

}
