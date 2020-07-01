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
  private let ownedNavigationController = UINavigationController()

  init(logicController purchaseLogicController: PurchaseLogicController) {
    logicController = purchaseLogicController

    super.init(nibName: nil, bundle: nil)

    let productViewController = ProductsViewController()

    logicController.setStateHandler { state in
      switch state {
      case .browsing(let products):
        productViewController.update(products: products)
      }
    }

    ownedNavigationController.setViewControllers([productViewController], animated: false)
  }

  override func loadView() {
    let view = UIView()
    install(ownedNavigationController, into: view)
    self.view = view
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
