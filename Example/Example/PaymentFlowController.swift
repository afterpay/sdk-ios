//
//  ViewController.swift
//  Example
//
//  Created by Adam Campbell on 12/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import UIKit

final class PaymentFlowController: UIViewController {

  private let ownedNavigationController: UINavigationController

  init() {
    ownedNavigationController = UINavigationController(
      rootViewController: DataEntryViewController()
    )

    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    view = UIView()

    install(ownedNavigationController)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
