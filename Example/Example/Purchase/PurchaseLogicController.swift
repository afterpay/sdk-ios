//
//  PurchaseLogicController.swift
//  Example
//
//  Created by Adam Campbell on 1/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Foundation

final class PurchaseLogicController {

  enum Command {
    case updateProducts([ProductDisplay])
    case showCart(CartDisplay)
    case showAfterpayCheckout(email: String, amount: String)
    case showAlertForErrorMessage(String)
    case showSuccessWithMessage(String)
  }

  var commandHandler: (Command) -> Void = { _ in } {
    didSet { commandHandler(.updateProducts(productDisplayModels)) }
  }

  private let products: [Product]
  private let email: String
  private let currencyCode: String

  private var quantities: [UUID: UInt] = [:]

  private var productDisplayModels: [ProductDisplay] {
    ProductDisplay.products(products, quantities: quantities, currencyCode: currencyCode)
  }

  private var total: Decimal {
    products.reduce(into: .zero) { total, product in
      let quantity = quantities[product.id] ?? 0
      total += product.price * Decimal(quantity)
    }
  }

  init(
    products: [Product] = .stub,
    email: String,
    currencyCode: String
  ) {
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
    let productsInCart = productDisplayModels.filter { (quantities[$0.id] ?? 0) > 0 }
    let cart = CartDisplay(products: productsInCart, total: total, currencyCode: currencyCode)
    commandHandler(.showCart(cart))
  }

  func payWithAfterpay() {
    let formatter = CurrencyFormatter(currencyCode: currencyCode)
    let amount = formatter.string(from: total)

    commandHandler(.showAfterpayCheckout(email: email, amount: amount))
  }

  func success(with token: String) {
    quantities = [:]
    commandHandler(.updateProducts(productDisplayModels))
    commandHandler(.showSuccessWithMessage("Success with: \(token)"))
  }

  func cancelled(with reason: CheckoutResult.CancellationReason) {
    let errorMessageToShow: String?

    switch reason {
    case .networkError(let error):
      errorMessageToShow = error.localizedDescription
    case .userInitiated:
      errorMessageToShow = nil
    case .invalidURL(let url):
      errorMessageToShow = "URL: \(url.absoluteString) is invalid for Afterpay Checkout"
    }

    if let errorMessage = errorMessageToShow {
      commandHandler(.showAlertForErrorMessage(errorMessage))
    }
  }

}
