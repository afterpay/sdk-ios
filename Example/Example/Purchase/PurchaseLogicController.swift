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
    case showAfterpayCheckout
    case provideCheckoutTokenResult(TokenResult)
    case provideShippingOptionsResult(ShippingOptionsResult)
    case showAlertForErrorMessage(String)
    case showSuccessWithMessage(String)
  }

  var commandHandler: (Command) -> Void = { _ in } {
    didSet { commandHandler(.updateProducts(productDisplayModels)) }
  }

  typealias CheckoutResponseProvider = (
    _ email: String,
    _ amount: String,
    _ completion: @escaping (Result<CheckoutsResponse, Error>) -> Void
  ) -> Void

  private let checkoutResponseProvider: CheckoutResponseProvider
  private let products: [Product]
  private var email: String { Settings.email }
  private var currencyCode: String { Settings.currencyCode }

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
    checkoutResponseProvider: @escaping CheckoutResponseProvider,
    products: [Product] = .stub
  ) {
    self.checkoutResponseProvider = checkoutResponseProvider
    self.products = products
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
    commandHandler(.showAfterpayCheckout)
  }

  func loadCheckout() {
    let formatter = CurrencyFormatter(currencyCode: currencyCode)
    let amount = formatter.string(from: total)

    checkoutResponseProvider(email, amount) { [weak self] result in
      let tokenResult = result.map(\.token)
      self?.commandHandler(.provideCheckoutTokenResult(tokenResult))
    }
  }

  func selectAddress(address: ShippingAddress) {
    let shippingOptions = [
      ShippingOption(
        id: "standard",
        name: "Standard",
        description: "3 - 5 days",
        shippingAmount: Money(amount: "0.00", currency: "AUD"),
        orderAmount: Money(amount: "50.00", currency: "AUD")
      ),
      ShippingOption(
        id: "priority",
        name: "Priority",
        description: "Next business day",
        shippingAmount: Money(amount: "10.00", currency: "AUD"),
        orderAmount: Money(amount: "60.00", currency: "AUD")
      ),
    ]

    let result: ShippingOptionsResult = .success(shippingOptions)
    commandHandler(.provideShippingOptionsResult(result))
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
