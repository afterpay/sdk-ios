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

final class AppFlowController: UIViewController {

  typealias URLProvider = (
    _ email: String,
    _ completion: @escaping (Result<URL, Error>) -> Void
  ) throws -> Void

  private let checkoutUrlProvider: URLProvider
  private let ownedNavigationController = UINavigationController()

  init(checkoutUrlProvider: @escaping URLProvider) {
    self.checkoutUrlProvider = checkoutUrlProvider

    super.init(nibName: nil, bundle: nil)

    let checkout = { [unowned self] in self.checkout() }
    let checkoutViewController = CheckoutViewController(checkout: checkout)

    let settingsItem = UIBarButtonItem(
      title: "Settings",
      style: .plain,
      target: self,
      action: #selector(didTapSettings)
    )

    checkoutViewController.navigationItem.setRightBarButton(settingsItem, animated: false)

    ownedNavigationController.setViewControllers([checkoutViewController], animated: false)
  }

  override func loadView() {
    view = UIView()

    install(ownedNavigationController)
  }

  // MARK: Checkout

  private func checkout() {
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

    let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

    let presentAlert = { [unowned self] (message: String) in
      alert.message = message
      self.present(alert, animated: true, completion: nil)
    }

    do {
      try checkoutUrlProvider(Settings.email) { result in
        switch result {
        case .success(let url):
          DispatchQueue.main.async { presentCheckout(url) }
        case .failure:
          DispatchQueue.main.async { presentAlert("Failed to retrieve checkout url") }
        }
      }
    } catch {
      presentAlert("Invalid host and port settings")
    }
  }

  // MARK: Settings

  @objc private func didTapSettings() {
    let settingsViewController = SettingsViewController(
      settings: [Settings.$email, Settings.$host, Settings.$port]
    )

    let navigationController = UINavigationController(rootViewController: settingsViewController)

    present(navigationController, animated: true, completion: nil)
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
