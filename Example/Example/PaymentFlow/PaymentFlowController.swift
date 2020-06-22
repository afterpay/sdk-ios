//
//  ViewController.swift
//  Example
//
//  Created by Adam Campbell on 12/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Foundation
import UIKit

final class PaymentFlowController: UIViewController {

  typealias URLProvider = (
    _ email: String,
    _ completion: @escaping (Result<URL, Error>) -> Void
  ) -> Void

  private let checkoutUrlProvider: URLProvider
  private let ownedNavigationController = UINavigationController()

  init(checkoutUrlProvider: @escaping URLProvider) {
    self.checkoutUrlProvider = checkoutUrlProvider

    super.init(nibName: nil, bundle: nil)

    let dataEntryViewController = DataEntryViewController { [unowned self] email in
      self.didEnter(email: email)
    }

    let settingsItem = UIBarButtonItem(title: "Settings", style: .plain, target: nil, action: nil)
    dataEntryViewController.navigationItem.setRightBarButton(settingsItem, animated: false)
    dataEntryViewController.title = "Pay with Afterpay"

    ownedNavigationController.setViewControllers([dataEntryViewController], animated: false)
  }

  override func loadView() {
    view = UIView()

    install(ownedNavigationController)
  }

  // MARK: Checkout

  private func didEnter(email: String) {
    let presentCheckout = { [unowned self] checkoutUrl in
      Afterpay.presentCheckout(
        over: self,
        loading: checkoutUrl,
        cancelHandler: {
          let messageViewController = MessageViewController(message: "Payment cancelled")
          self.ownedNavigationController.pushViewController(messageViewController, animated: true)
        },
        successHandler: { token in
          let message = "Succeeded with token: \(token)"
          let messageViewController = MessageViewController(message: message)
          self.ownedNavigationController.pushViewController(messageViewController, animated: true)
        }
      )
    }

    checkoutUrlProvider(email) { result in
      switch result {
      case .success(let url):
        DispatchQueue.main.async { presentCheckout(url) }
      case .failure:
        break
      }
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
