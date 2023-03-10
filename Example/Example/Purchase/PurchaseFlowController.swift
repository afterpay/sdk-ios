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

    // This configuration object may also be passed directly into calls to
    // `Afterpay.presentCheckoutV3Modally` and `Afterpay.fetchMerchantConfiguration`
    Afterpay.setV3Configuration(.init(
      shopDirectoryMerchantId: "822ce7ffc2fa41258904baad1d0fe07351e89375108949e8bd951d387ef0e932",
      region: .US,
      environment: .sandbox
    ))

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

    Afterpay.fetchMerchantConfiguration { result in
      switch result {
      case .success(let configuration):
        Afterpay.setConfiguration(configuration)
      case .failure(let error):
        let alert = AlertFactory.alert(for: error.localizedDescription)
        self.present(alert, animated: true)
      }
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
        case .cartDidLoad(let button):
          logicController.retrieveCashAppToken(cashButton: button)
        case .didTapPay:
          logicController.payWithAfterpay()
        case .didTapCashAppPay:
          logicController.payWithCashApp()
        case .optionsChanged(.buyNow):
          logicController.toggleCheckoutV2Option(\.buyNow)
        case .optionsChanged(.pickup):
          logicController.toggleCheckoutV2Option(\.pickup)
        case .optionsChanged(.shippingOptionRequired):
          logicController.toggleCheckoutV2Option(\.shippingOptionRequired)
        case .optionsChanged(.expressToggled):
          logicController.toggleExpressCheckout()
        case .didTapSingleUseCardButton:
          logicController.payWithAfterpayV3()
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
          // when launching the checkout with V2, the token must be generated
          // with 'popupOriginUrl' set to 'https://static.afterpay.com' under the
          // top level 'merchant' object
          logicController.success(with: token)
        case .cancelled(let reason):
          logicController.cancelled(with: reason)
        }
      }

    case .showAfterpayCheckoutV3(let consumer, let cart):
      Afterpay.presentCheckoutV3Modally(
        over: ownedNavigationController,
        consumer: consumer,
        orderTotal: OrderTotal(total: cart.total, shipping: 0, tax: 0),
        items: cart.products,
        buyNow: cart.checkoutV2Options.buyNow ?? false,
        requestHandler: APIClient.live.session.dataTask
      ) { result in
        switch result {
        case .success(let data):
          let controller = SingleUseCardResultViewController(data: data)
          navigationController.pushViewController(controller, animated: true)
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

    case .showCashSuccess(let amount, let cashTag, let grants):
      let cashReceiptViewController = CashAppGrantsViewController(amount: amount, cashTag: cashTag, grants: grants)
      let viewControllers = [productsViewController, cashReceiptViewController]
      navigationController.setViewControllers(viewControllers, animated: true)
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
