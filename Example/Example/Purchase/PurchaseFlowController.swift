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
      onShippingAddressDidChange: logicController.selectAddress
    )

    Afterpay.setCheckoutV2Handler(checkoutHandler)

    // This configuration object may also be passed directly into calls to
    // `Afterpay.presentCheckoutV3Modally` and `Afterpay.fetchMerchantConfiguration`
    Afterpay.setV3Configuration(.init(
      shopDirectoryId: "cd6b7914412b407d80aaf81d855d1105",
      shopDirectoryMerchantId: "822ce7ffc2fa41258904baad1d0fe07351e89375108949e8bd951d387ef0e932",
      merchantPublicKey: "",
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
        // Do something with the configuration object here
        print(configuration)
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
        case .success(.token(let token)):
          logicController.success(with: token)
        // Here for backward compatibility; this case will never be hit
        case .success(_):
          break
        case .cancelled(let reason):
          logicController.cancelled(with: reason)
        }
      }

    case .showAfterpayCheckoutV2(let options):
      Afterpay.presentCheckoutV2Modally(over: ownedNavigationController, options: options) { result in
        switch result {
        case .success(.token(let token)):
          logicController.success(with: token)
        // Here for backward compatibility; this case will never be hit
        case .success(_):
          break
        case .cancelled(let reason):
          logicController.cancelled(with: reason)
        }
      }

    case .showAfterpayCheckoutV3(let consumer, let total):
      Afterpay.presentCheckoutV3Modally(
        over: ownedNavigationController,
        consumer: consumer,
        total: total,
        requestHandler: APIClient.live.session.dataTask
      ) { result in
        switch result {
        // Here for backward compatibility; this case will never be hit
        case .success(.token(_)):
          break
        case .success(.singleUseCard(_, let validUntil, let cardDetails)):
          let controller = SingleUseCardResultViewController(
            details: cardDetails,
            authorizationExpiration: validUntil
          )
          navigationController.pushViewController(controller, animated: true)
        case .cancelled(let reason):
          logicController.cancelled(with: reason)
        }
      }

    case .provideCheckoutTokenResult(let tokenResult):
      checkoutHandler.provideTokenResult(tokenResult: tokenResult)

    case .provideShippingOptionsResult(let shippingOptionsResult):
      checkoutHandler.provideShippingOptionsResult(result: shippingOptionsResult)

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

struct Consumer: CheckoutV3Consumer {
  var email: String
  var givenNames: String? { nil }
  var surname: String? { nil }
  var phoneNumber: String? { nil }
}
