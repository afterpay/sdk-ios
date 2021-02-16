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
  private let ownedNavigationController: UINavigationController
  private let productsViewController: ProductsViewController

  init(logicController purchaseLogicController: PurchaseLogicController) {
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

  private var checkoutTokenResultCompletion: CheckoutTokenResultCompletion?
  private var shippingOptionsCompletion: ShippingOptionsCompletion?

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

    case .showAfterpayCheckout:
      Afterpay.presentCheckoutV2Modally(
        over: ownedNavigationController,
        didCommenceCheckout: { [weak self] in
          self?.checkoutTokenResultCompletion = $0
          logicController.loadCheckout()
        },
        shippingAddressDidChange: { [weak self] address, completion in
          self?.shippingOptionsCompletion = completion
          logicController.selectAddress(address: address)
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

    case .provideCheckoutTokenResult(let tokenResult):
      checkoutTokenResultCompletion?(tokenResult)
      checkoutTokenResultCompletion = nil

    case .provideShippingOptions(let shippingOptions):
      shippingOptionsCompletion?(shippingOptions)
      shippingOptionsCompletion = nil

    case .showAlertForErrorMessage(let errorMessage):
      let alert = AlertFactory.alert(for: errorMessage)
      navigationController.present(alert, animated: true, completion: nil)

    case .showSuccessWithMessage(let message):
      let messageViewController = MessageViewController(message: message)
      let viewControllers = [productsViewController, messageViewController]
      navigationController.setViewControllers(viewControllers, animated: true)
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
