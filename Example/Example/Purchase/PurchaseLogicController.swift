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

  enum Command {
    case updateProducts([ProductDisplay])
    case showCart(CartDisplay)
    case showAfterpayCheckout(URL)
    case showAlertForCheckoutURLError(Error)
  }

  var commandHandler: (Command) -> Void = { _ in } {
    didSet { commandHandler(.updateProducts(productDisplayModels)) }
  }

  private let checkoutURLProvider: CheckoutURLProvider
  private let products: [Product]
  private let email: String
  private let currencyCode: String

  private var quantities: [UUID: UInt] = [:]
  private var productDisplayModels: [ProductDisplay] {
    ProductDisplay.products(products, quantities: quantities, currencyCode: currencyCode)
  }

  init(
    checkoutURLProvider: @escaping CheckoutURLProvider,
    products: [Product] = .stub,
    email: String,
    currencyCode: String
  ) {
    self.checkoutURLProvider = checkoutURLProvider
    self.products = products
    self.email = email
    self.currencyCode = currencyCode
  }

  func incrementQuantityOfProduct(with id: UUID) {
    let quantity = quantities[id] ?? 0
    quantities[id] = quantity == .max ? .max : quantity + 1
    commandHandler(.updateProducts(productDisplayModels))
  }

  func decrementQuantityOfProduct(with id: UUID) {
    let quantity = quantities[id] ?? 0
    quantities[id] = quantity == 0 ? 0 : quantity - 1
    commandHandler(.updateProducts(productDisplayModels))
  }

  func viewCart() {
    let cart = CartDisplay(products: products, quantities: quantities, currencyCode: currencyCode)
    commandHandler(.showCart(cart))
  }

  func payWithAfterpay() {
    checkoutURLProvider(email) { [commandHandler] result in
      switch result {
      case .success(let url):
        commandHandler(.showAfterpayCheckout(url))
      case .failure(let error):
        commandHandler(.showAlertForCheckoutURLError(error))
      }
    }
  }

}
