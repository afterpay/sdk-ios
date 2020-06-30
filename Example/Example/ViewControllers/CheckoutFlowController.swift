//
//  CheckoutFlowController.swift
//  Example
//
//  Created by Adam Campbell on 30/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

final class CheckoutFlowController: UIViewController {

  private let ownedNavigationController = UINavigationController()

  init() {
    super.init(nibName: nil, bundle: nil)
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
