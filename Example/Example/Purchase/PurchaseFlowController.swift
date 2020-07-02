//
//  PurchaseFlowController.swift
//  Example
//
//  Created by Adam Campbell on 30/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Foundation

final class PurchaseFlowController: UIViewController, UINavigationControllerDelegate {

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

    ownedNavigationController.delegate = self
  }

  override func loadView() {
    let view = UIView()
    install(ownedNavigationController, into: view)
    self.view = view
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    logicController.stateHandler = { [unowned self] state in
      switch state {
      case .products(let products):
        self.productsViewController.update(products: products)

      case .cart(.displaying(let cart)):
        let cartViewController = CartViewController(cart: cart) { event in
          switch event {
          case .pay:
            self.logicController.pay()
          }
        }

        self.ownedNavigationController.pushViewController(cartViewController, animated: true)

      case .cart(.presenting(let url)):
        Afterpay.presentCheckoutModally(
          over: self.ownedNavigationController,
          loading: url,
          animated: true,
          completion: { result in
            switch result {
            case .success(let token): print(token)
            case .cancelled: break
            }
          }
        )
      }
    }

  }

  // MARK: UINavigationControllerDelegate

  func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController,
    animated: Bool
  ) {
    if viewController == productsViewController {
      logicController.viewProducts()
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
