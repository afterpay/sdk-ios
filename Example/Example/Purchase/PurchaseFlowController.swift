//
//  PurchaseFlowController.swift
//  Example
//
//  Created by Adam Campbell on 30/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Foundation

final class PurchaseFlowController: UIViewController {

  typealias CheckoutURLProvider = (
    _ email: String,
    _ amount: String,
    _ completion: @escaping (Result<URL, Error>) -> Void
  ) -> Void

  private let urlProvider: CheckoutURLProvider
  private let logicController: PurchaseLogicController
  private let ownedNavigationController: UINavigationController
  private let productsViewController: ProductsViewController

  init(
    urlProvider checkoutURLProvider: @escaping CheckoutURLProvider,
    logicController purchaseLogicController: PurchaseLogicController
  ) {
    urlProvider = checkoutURLProvider
    logicController = purchaseLogicController

    productsViewController = ProductsViewController { event in
      switch event {
      case .productEvent(.didTapPlus(let productId)):
        purchaseLogicController.incrementQuantityOfProduct(with: productId)

      case .productEvent(.didTapMinus(let productId)):
        purchaseLogicController.decrementQuantityOfProduct(with: productId)

      case .viewCart:
        purchaseLogicController.viewCart()
      }
    }

    ownedNavigationController = UINavigationController(rootViewController: productsViewController)

    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    self.view = UIView()
    install(ownedNavigationController)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    logicController.commandHandler = { [unowned self] command in
      DispatchQueue.main.async { self.execute(command: command) }
    }
  }

  private func execute(command: PurchaseLogicController.Command) {
    let logicController = self.logicController
    let navigationController = self.ownedNavigationController

    switch command {
    case .updateProducts(let products):
      productsViewController.update(products: products)

    case .showCart(let cart):
      let cartViewController = CartViewController(cart: cart) { event in
        switch event {
        case .didTapPay:
          logicController.payWithAfterpay()
        }
      }

      navigationController.pushViewController(cartViewController, animated: true)

    case .showAfterpayCheckout(let email, let amount):
      presentAfterpayCheckoutModally(email: email, amount: amount, language: Settings.language)

    case .showAlertForErrorMessage(let errorMessage):
      let alert = AlertFactory.alert(for: errorMessage)
      navigationController.present(alert, animated: true, completion: nil)

    case .showSuccessWithMessage(let message):
      let messageViewController = MessageViewController(message: message)
      let viewControllers = [productsViewController, messageViewController]
      navigationController.setViewControllers(viewControllers, animated: true)
    }
  }

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

  private func presentAfterpayCheckoutModally(email: String, amount: String, language: Language) {
    let logicController = self.logicController
    let viewController = self.ownedNavigationController

    let transformUrl = { (url: URL) -> URL in
      var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
      let queryItems = (components?.queryItems ?? []) + [
        URLQueryItem(name: "pickup", value: "false"),
        URLQueryItem(name: "buyNow", value: "false"),
      ]
      components?.queryItems = queryItems
      return components?.url ?? url
    }

    switch language {
    case .swift:
      Afterpay.presentInteractiveCheckoutModally(
        over: viewController,
        didCommenceCheckout: { [urlProvider] completion in
          urlProvider(email, amount) { result in
            completion(result.map(transformUrl))
          }
        },
        shippingAddressDidChange: { [shippingOptions] _, completion in
          completion(shippingOptions)
        },
        completion: { result in
          switch result {
          case .success(let token):
            logicController.success(with: token)
          case .cancelled(let reason):
            logicController.cancelled(with: reason)
          }
        }
      )

    case .objectiveC:
      Objc.presentCheckoutModally(
        over: viewController,
        loading: nil,
        successHandler: { token in logicController.success(with: token) },
        userInitiatedCancelHandler: { logicController.cancelled(with: .userInitiated) },
        networkErrorCancelHandler: { error in logicController.cancelled(with: .networkError(error)) },
        invalidURLCancelHandler: { url in logicController.cancelled(with: .invalidURL(url)) }
      )
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
