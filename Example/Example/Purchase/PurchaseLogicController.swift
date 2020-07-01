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

  private let checkoutURLProvider: CheckoutURLProvider
  private let products: [Product] = .stub

  private var productQuantities: [UUID: UInt]
  private var stateHandler: PurchaseStateHandler = { _ in }

  private var productDisplayModels: [ProductDisplay] {
    products.map { ProductDisplay(product: $0, quantity: productQuantities[$0.id] ?? 0) }
  }

  init(checkoutURLProvider: @escaping CheckoutURLProvider) {
    self.checkoutURLProvider = checkoutURLProvider
    self.productQuantities = products.reduce(into: [UUID: UInt](), { quantities, product in
      quantities[product.id] = 0
    })
  }

  func setStateHandler(stateHandler: @escaping PurchaseStateHandler) {
    self.stateHandler = stateHandler
    stateHandler(.browsing(products: productDisplayModels))
  }

  func incrementQuantityOfProduct(with id: UUID) {
    let quantity = productQuantities[id] ?? 0
    productQuantities[id] = quantity == .max ? .max : quantity + 1
    stateHandler(.browsing(products: productDisplayModels))
  }

  func decrementQuantityOfProduct(with id: UUID) {
    let quantity = productQuantities[id] ?? 0
    productQuantities[id] = quantity == 0 ? 0 : quantity - 1
    stateHandler(.browsing(products: productDisplayModels))
  }

}
