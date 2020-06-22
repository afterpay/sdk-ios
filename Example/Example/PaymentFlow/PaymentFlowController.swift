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

  private let ownedNavigationController: UINavigationController

  typealias UrlProvider = (
    _ email: String,
    _ completion: @escaping (Result<URL, Error>) -> Void
  ) -> Void

  init(checkoutUrlProvider: @escaping UrlProvider) {
    ownedNavigationController = UINavigationController()

    super.init(nibName: nil, bundle: nil)

    let dataEntryViewController = DataEntryViewController { [unowned self] email in
      let navigationController = self.ownedNavigationController

      let presentCheckout = { checkoutUrl in
        Afterpay.presentCheckout(
          over: self,
          loading: checkoutUrl,
          cancelHandler: {
            let messageViewController = MessageViewController(message: "Payment cancelled")
            navigationController.pushViewController(messageViewController, animated: true)
          },
          successHandler: { token in
            let message = "Succeeded with token: \(token)"
            let messageViewController = MessageViewController(message: message)
            navigationController.pushViewController(messageViewController, animated: true)
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

    ownedNavigationController.setViewControllers([dataEntryViewController], animated: false)
  }

  override func loadView() {
    view = UIView()

    install(ownedNavigationController)
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
