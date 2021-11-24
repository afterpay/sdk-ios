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

  private let logicController: PurchaseLogicController
  private let productsViewController: ProductsViewController
  private let ownedNavigationController: UINavigationController
  private let checkoutHandler: CheckoutHandler
  private let widgetHandler: WidgetHandler

  init(logicController purchaseLogicController: PurchaseLogicController) {
    logicController = purchaseLogicController

    productsViewController = ProductsViewController { [logicController] event in
      switch event {
      case .productEvent(.didTapPlus(let productId)):
        logicController.incrementQuantityOfProduct(with: productId)

      case .productEvent(.didTapMinus(let productId)):
        logicController.decrementQuantityOfProduct(with: productId)

      case .viewCart:
        logicController.viewCart()
      }
    }

    ownedNavigationController = UINavigationController(rootViewController: productsViewController)

    checkoutHandler = CheckoutHandler(
      didCommenceCheckout: logicController.loadCheckoutToken,
      onShippingAddressDidChange: logicController.selectAddress,
      onShippingOptionDidChange: logicController.selectShipping
    )

    Afterpay.setCheckoutV2Handler(checkoutHandler)

    widgetHandler = WidgetEventHandler()
    Afterpay.setWidgetHandler(widgetHandler)

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

  // swiftlint:disable:next cyclomatic_complexity
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
        case .optionsChanged(.buyNow):
          logicController.toggleCheckoutV2Option(\.buyNow)
        case .optionsChanged(.pickup):
          logicController.toggleCheckoutV2Option(\.pickup)
        case .optionsChanged(.shippingOptionRequired):
          logicController.toggleCheckoutV2Option(\.shippingOptionRequired)
        case .optionsChanged(.expressToggled):
          logicController.toggleExpressCheckout()
        }
      }

      navigationController.pushViewController(cartViewController, animated: true)

    case .showAfterpayCheckoutV1(let checkoutURL):
      Afterpay.presentCheckoutModally(
        over: ownedNavigationController,
        loading: checkoutURL
      ) { result in
        switch result {
        case .success(let token):
          logicController.success(with: token)
        case .cancelled(let reason):
          logicController.cancelled(with: reason)
        }
      }

    case .showAfterpayCheckoutV2(let options):
      Afterpay.presentCheckoutV2Modally(over: ownedNavigationController, options: options) { result in
        switch result {
        case .success(let token):
          logicController.success(with: token)
        case .cancelled(let reason):
          logicController.cancelled(with: reason)
        }
      }

    case .provideCheckoutTokenResult(let tokenResult):
      checkoutHandler.provideTokenResult(tokenResult: tokenResult)

    case .provideShippingOptionsResult(let shippingOptionsResult):
      checkoutHandler.provideShippingOptionsResult(result: shippingOptionsResult)

    case .provideShippingOptionResult(let shippingOptionResult):
      checkoutHandler.provideShippingOptionResult(result: shippingOptionResult)

    case .showAlertForErrorMessage(let errorMessage):
      let alert = AlertFactory.alert(for: errorMessage)
      navigationController.present(alert, animated: true, completion: nil)

    case .showSuccessWithMessage(let message, let token):
      let widgetViewController = WidgetViewController(title: message, token: token)
      let viewControllers = [productsViewController, widgetViewController]
      navigationController.setViewControllers(viewControllers, animated: true)
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
