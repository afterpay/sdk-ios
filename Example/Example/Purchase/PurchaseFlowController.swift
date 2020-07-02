//
//  PurchaseFlowController.swift
//  Example
//
//  Created by Adam Campbell on 30/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

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

    logicController.stateHandler = { [unowned self] state in
      switch state {
      case .browsing(let products):
        self.productsViewController.update(products: products)
      case .viewing(let cart):
        let cartViewController = CartViewController(cart: cart)
        self.ownedNavigationController.pushViewController(cartViewController, animated: true)
      }
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
