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
    let view = UIView()
    install(ownedNavigationController, into: view)
    self.view = view
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    logicController.stateHandler = { [productsViewController] state in
      productsViewController.update(products: state.products)
    }

    logicController.commandHandler = { [unowned self] command in
      let navigationController = self.ownedNavigationController
      let action: () -> Void

      switch command {
      case .showCart(let cart):
        let cartViewController = CartViewController(cart: cart) { event in
          switch event {
          case .didTapPay:
            self.logicController.payWithAfterpay()
          }
        }

        action = { navigationController.pushViewController(cartViewController, animated: true) }

      case .showAfterpayCheckout(let url):
        action = {
          Afterpay.presentCheckoutModally(over: navigationController, loading: url) { result in
            switch result {
            case .success(let token):
              let messageViewController = MessageViewController(message: "Success with: \(token)")
              let viewControllers = [self.productsViewController, messageViewController]
              navigationController.setViewControllers(viewControllers, animated: true)

            case .cancelled:
              break
            }
          }
        }

      case .showAlertForCheckoutURLError(let error):
        let alert = AlertFactory.alert(for: error)

        action = { navigationController.present(alert, animated: true, completion: nil) }
      }

      DispatchQueue.main.async(execute: action)
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
