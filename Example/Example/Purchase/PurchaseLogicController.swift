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

    case showAfterpayCheckoutV1(checkoutURL: URL)

    case showAfterpayCheckoutV2(CheckoutV2Options)
    case provideCheckoutTokenResult(TokenResult)
    case provideShippingOptionsResult(ShippingOptionsResult)
    case provideShippingOptionResult(ShippingOptionUpdateResult)

    case showAlertForErrorMessage(String)
    case showSuccessWithMessage(String, Token)
  }

  var commandHandler: (Command) -> Void = { _ in } {
    didSet { commandHandler(.updateProducts(productDisplayModels)) }
  }

  typealias CheckoutResponseProvider = (
    _ email: String,
    _ amount: String,
    _ checkoutMode: CheckoutMode,
    _ completion: @escaping (Result<CheckoutsResponse, Error>) -> Void
  ) -> Void

  typealias ConfigurationProvider = () -> Configuration

  private let checkoutResponseProvider: CheckoutResponseProvider
  private let configurationProvider: ConfigurationProvider
  private let products: [Product]
  private var email: String { Settings.email }
  private var currencyCode: String { configurationProvider().currencyCode }

  private var quantities: [UUID: UInt] = [:]

  private var checkoutV2Options = CheckoutV2Options(
    pickup: false,
    buyNow: false,
    shippingOptionRequired: true,
    enableSingleShippingOptionUpdate: true
  )

  private var expressCheckout: Bool = true

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
    configurationProvider: @escaping ConfigurationProvider,
    products: [Product] = .stub
  ) {
    self.checkoutResponseProvider = checkoutResponseProvider
    self.configurationProvider = configurationProvider
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

  func toggleCheckoutV2Option(_ option: WritableKeyPath<CheckoutV2Options, Bool?>) {
    let currentValue = checkoutV2Options[keyPath: option] ?? false
    checkoutV2Options[keyPath: option] = !currentValue
  }

  func toggleExpressCheckout() {
    expressCheckout.toggle()
  }

  func viewCart() {
    let productsInCart = productDisplayModels.filter { (quantities[$0.id] ?? 0) > 0 }
    let cart = CartDisplay(
      products: productsInCart,
      total: total,
      currencyCode: currencyCode,
      expressCheckout: expressCheckout,
      initialCheckoutOptions: checkoutV2Options
    )
    commandHandler(.showCart(cart))
  }

  func payWithAfterpay() {
    if expressCheckout {
      commandHandler(.showAfterpayCheckoutV2(checkoutV2Options))
    } else {
      loadCheckoutURL(then: { self.commandHandler(.showAfterpayCheckoutV1(checkoutURL: $0)) })
    }
  }

  func loadCheckoutURL(then command: @escaping (URL) -> Void) {
    let formatter = CurrencyFormatter(currencyCode: currencyCode)
    let amount = formatter.string(from: total)

    checkoutResponseProvider(email, amount, .v1) { result in
      guard let url = try? result.map(\.url).get() else {
        return
      }
      command(url)
    }
  }

  func loadCheckoutToken() {
    let formatter = CurrencyFormatter(currencyCode: currencyCode)
    let amount = formatter.string(from: total)

    checkoutResponseProvider(email, amount, .v2) { [weak self] result in
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
        shippingAmount: Money(amount: "0.00", currency: currencyCode),
        orderAmount: Money(amount: "50.00", currency: currencyCode),
        taxAmount: Money(amount: "2.00", currency: currencyCode)
      ),
      ShippingOption(
        id: "priority",
        name: "Priority",
        description: "Next business day",
        shippingAmount: Money(amount: "10.00", currency: currencyCode),
        orderAmount: Money(amount: "60.00", currency: currencyCode),
        taxAmount: Money(amount: "2.00", currency: currencyCode)
      ),
    ]

    let result: ShippingOptionsResult = .success(shippingOptions)
    commandHandler(.provideShippingOptionsResult(result))
  }

  func selectShipping(shippingOption: ShippingOption) {
    if shippingOption.id == "standard" {
      let updatedShippingOption = ShippingOptionUpdate(
        id: shippingOption.id,
        shippingAmount: Money(amount: "0.00", currency: currencyCode),
        orderAmount: Money(amount: "42.00", currency: currencyCode),
        taxAmount: Money(amount: "8.00", currency: currencyCode)
      )

      let result: ShippingOptionUpdateResult = .success(updatedShippingOption)
      commandHandler(.provideShippingOptionResult(result))
    } else {
      commandHandler(.provideShippingOptionResult(nil))
    }
  }

  func success(with token: String) {
    quantities = [:]
    commandHandler(.updateProducts(productDisplayModels))
    commandHandler(.showSuccessWithMessage("Success", token))
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
