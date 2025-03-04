//
//  PurchaseLogicController.swift
//  Example
//
//  Created by Adam Campbell on 1/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Foundation
import PayKit
import PayKitUI

// swiftlint:disable:next type_body_length
final class PurchaseLogicController {

  enum Command {
    case updateProducts([ProductDisplay])
    case showCart(CartDisplay)

    case showAfterpayCheckoutV1(checkoutURL: URL)

    case showAfterpayCheckoutV2(CheckoutV2Options)
    case showAfterpayCheckoutV3(consumer: Consumer, cart: CartDisplay)
    case provideCheckoutTokenResult(TokenResult)
    case provideShippingOptionsResult(ShippingOptionsResult)
    case provideShippingOptionResult(ShippingOptionUpdateResult)

    case showAlertForErrorMessage(String)
    case showSuccessWithMessage(String, Token)
    case showCashSuccess(String, String, [CustomerRequest.Grant])

    case showSuccessForV3WithCashAppPay(String, ConfirmationV3.CashAppPayResponse)
  }

  var commandHandler: (Command) -> Void = { _ in } {
    didSet { commandHandler(.updateProducts(productDisplayModels)) }
  }

  typealias CheckoutResponseProvider = (
    _ email: String,
    _ amount: String,
    _ checkoutMode: CheckoutMode,
    _ isCashApp: Bool,
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

  private let buttonCashAppPayCheckout = ButtonCashAppPayCheckout()

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

  func setExpressCheckoutEnabled(_ isEnabled: Bool) {
    expressCheckout = isEnabled
  }

  func buildCart() -> CartDisplay {
    let productsInCart = productDisplayModels.filter { (quantities[$0.id] ?? 0) > 0 }
    return CartDisplay(
      products: productsInCart,
      total: total,
      currencyCode: currencyCode,
      expressCheckout: expressCheckout,
      initialCheckoutOptions: checkoutV2Options
    )
  }

  func viewCart() {
    commandHandler(.showCart(buildCart()))
  }

  func payWithAfterpay() {
    if expressCheckout {
      commandHandler(.showAfterpayCheckoutV2(checkoutV2Options))
    } else {
      loadCheckoutURL(then: { self.commandHandler(.showAfterpayCheckoutV1(checkoutURL: $0)) })
    }
  }

  func payWithAfterpayV3() {
    commandHandler(.showAfterpayCheckoutV3(
      consumer: Consumer(email: email),
      cart: buildCart()
    ))
  }

  func payWithAfterpayV3WithCashAppPay() {
    buttonCashAppPayCheckout.delegate = self
    buttonCashAppPayCheckout.checkoutV3(
      consumer: Consumer(email: email),
      cartTotal: buildCart().total
    )
  }

  func payWithCashApp() {
    guard let cashRequest else {
      return
    }
    paykit?.authorizeCustomerRequest(cashRequest)
  }

  private var cashButton: CashAppPayButton?

  private var cashRequest: CustomerRequest?

  static var cashData: CashAppSigningData?

  private lazy var paykit: CashAppPay? = {
    guard let clientId = Afterpay.cashAppClientId else {
      assertionFailure("Couldn't get cash app client id")
      return nil
    }

    let paykitSdkEnv =
      Afterpay.environment == .production ? CashAppPay.Endpoint.production : CashAppPay.Endpoint.sandbox
    let sdk = CashAppPay(clientID: clientId, endpoint: paykitSdkEnv)
    sdk.addObserver(self)

    return sdk
  }()

  private func setCashButtonEnabled(_ isEnabled: Bool) {
    cashButton?.isEnabled = isEnabled
  }

  func handleCashAppToken(token: Token) {
    Afterpay.signCashAppOrderToken(token) { result in
      switch result {
      case .success(let cashData):
        PurchaseLogicController.cashData = cashData

        if let paykit = self.paykit {
          paykit.createCustomerRequest(
            params: CreateCustomerRequestParams(
              actions: [
                .oneTimePayment(
                  scopeID: cashData.brandId,
                  money: Money(
                    amount: cashData.amount,
                    currency: .USD
                  )
                ),
              ],
              channel: .IN_APP,
              redirectURL: URL(string: "aftersnack://callback")!, // the cashData.redirectUri object could be used here
              referenceID: nil,
              metadata: nil
            )
          )
        }
      case .failed(let reason):
        PurchaseLogicController.cashData = nil
        print("didn't sign cash app order: \(reason)")
      }
    }
  }

  func retrieveCashAppToken(cashButton: CashAppPayButton? = nil) {
    if cashButton != nil {
      self.cashButton = cashButton
    }
    setCashButtonEnabled(false)

    guard !quantities.isEmpty else {
      return
    }

    let formatter = CurrencyFormatter(currencyCode: currencyCode)
    let amount = formatter.string(from: total)

    checkoutResponseProvider(email, amount, .v1, true) { [weak self] result in
      let tokenResult = result.map(\.token)

      switch tokenResult {
      case .success(let token):
        self?.handleCashAppToken(token: token)
      case .failure(let error):
        print(error)
      }
    }
  }

  func loadCheckoutURL(then command: @escaping (URL) -> Void) {
    let formatter = CurrencyFormatter(currencyCode: currencyCode)
    let amount = formatter.string(from: total)

    checkoutResponseProvider(email, amount, .v1, false) { result in
      guard let url = try? result.map(\.url).get() else {
        return
      }
      command(url)
    }
  }

  func loadCheckoutToken() {
    let formatter = CurrencyFormatter(currencyCode: currencyCode)
    let amount = formatter.string(from: total)

    checkoutResponseProvider(email, amount, .v2, false) { [weak self] result in
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
    // if standard shipping was selected, update the amounts
    // otherwise leave as is by passing nil
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
    case .unretrievableUrl:
      errorMessageToShow = nil
    case .invalidURL(let url):
      errorMessageToShow = "URL: \(url.absoluteString) is invalid for Afterpay Checkout"
    }

    if let errorMessage = errorMessageToShow {
      commandHandler(.showAlertForErrorMessage(errorMessage))
    }
  }

}

extension PurchaseLogicController: CashAppPayObserver {
  func stateDidChange(to state: CashAppPayState) {

    print("Cash app state change:", Mirror(reflecting: state).children.first?.label ?? "Unknown")

    switch state {
    case .notStarted,
      .creatingCustomerRequest,
        .updatingCustomerRequest,
        .redirecting,
        .polling,
        .apiError,
        .integrationError,
        .networkError,
        .unexpectedError,
        .refreshing:
      return
    case .readyToAuthorize(let request):
      setCashButtonEnabled(true)
      cashRequest = request
    case .approved(request: let request, grants: let grants):
      if
        PurchaseLogicController.cashData == nil ||
          request.customerProfile == nil ||
          grants.isEmpty {
        return
      }

      let customerProfile = request.customerProfile!
      let grant = grants.first!
      let cashData = PurchaseLogicController.cashData!

      quantities = [:]
      commandHandler(.updateProducts(productDisplayModels))

      let cashTag = customerProfile.cashtag
      let customerId = customerProfile.id

      let formatter = CurrencyFormatter(currencyCode: currencyCode)
      let total = grants.reduce(0) { $0 + ($1.action.money?.amount ?? 0) }
      let amount = formatter.string(from: Decimal(total) / 100)

      Afterpay.validateCashAppOrder(jwt: cashData.jwt, customerId: customerId, grantId: grant.id) { result in
        switch result {
        case .success(let data):
          print("validation data", data)
          self.commandHandler(.showCashSuccess(amount, cashTag, grants))
          return
        case .failed(let reason):
          switch reason {
          case .httpError(let errorCode, let message):
            print("validation failed (http)", errorCode, message)
            return
          default:
            print("validation failed:", reason)
          }
        }
      }
    case .declined:
      retrieveCashAppToken()
    }
  }
}

// MARK: - ButtonCashAppPayCheckoutDelegate

extension PurchaseLogicController: ButtonCashAppPayCheckoutDelegate {
  func didFinish(result: Result<ConfirmationV3.CashAppPayResponse, ButtonCashAppPayError>) {
    switch result {
    case .success(let data):
      commandHandler(.showSuccessForV3WithCashAppPay("Success", data))
    case let .failure(.checkout(error: error)):
      commandHandler(.showAlertForErrorMessage("V3 Checkout: error \(error)"))
    case let .failure(.checkoutReason(reason)):
      commandHandler(.showAlertForErrorMessage("V3 Checkout: reason \(reason)"))
    case .failure(.customerRequestMissingGrant):
      commandHandler(.showAlertForErrorMessage("Cash App Pay: missing grant"))
    case .failure(.customerRequestDeclined):
      commandHandler(.showAlertForErrorMessage("Cash App Pay: declined"))
    case let .failure(.customerRequest(error: error)):
      commandHandler(.showAlertForErrorMessage("Cash App Pay: error \(error)"))
    case let .failure(.confirmation(error: error)):
      commandHandler(.showAlertForErrorMessage("Confirmation: error \(error)"))
    }
  }
}
