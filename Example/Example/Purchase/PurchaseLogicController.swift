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
    case cart
  }

  private struct State {
    let products: [Product]
    var quantities: [UUID: UInt]
    var screen: Screen
    var handler: PurchaseStateHandler

    func didChange() {
      let state: PurchaseState

      switch screen {
      case .products:
        let productDisplayModels = [ProductDisplay](
          products: products,
          quantities: quantities,
          currencyCode: Settings.currencyCode,
          editable: true)
        state = .browsing(products: productDisplayModels)

      case .cart:
        let cart = CartDisplay(
          products: products,
          quantities: quantities,
          currencyCode: Settings.currencyCode)
        state = .viewing(cart: cart)
      }

      handler(state)
    }
  }

  var stateHandler: PurchaseStateHandler {
    get { state.handler }
    set { state.handler = newValue }
  }

  private let checkoutURLProvider: CheckoutURLProvider

  private var state: State {
    didSet { state.didChange() }
  }

  init(checkoutURLProvider: @escaping CheckoutURLProvider) {
    self.checkoutURLProvider = checkoutURLProvider

    let products: [Product] = .stub
    let quantities = products.reduce(into: [UUID: UInt](), { quantities, product in
      quantities[product.id] = 0
    })

    self.state = State(
      products: products,
      quantities: quantities,
      screen: .products,
      handler: { _ in }
    )
  }

  func incrementQuantityOfProduct(with id: UUID) {
    let quantity = (state.quantities[id] ?? 0)
    state.quantities[id] = quantity == .max ? .max : quantity + 1
  }

  func decrementQuantityOfProduct(with id: UUID) {
    let quantity = (state.quantities[id] ?? 0)
    state.quantities[id] = quantity == 0 ? 0 : quantity - 1
  }

  func viewCart() {
    state.screen = .cart
  }

}
