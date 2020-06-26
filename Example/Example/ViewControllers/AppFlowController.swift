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
  ) -> Void

  private let checkoutUrlProvider: URLProvider
  private let ownedTabBarController = UITabBarController()

  init(checkoutUrlProvider: @escaping URLProvider) {
    self.checkoutUrlProvider = checkoutUrlProvider

    super.init(nibName: nil, bundle: nil)

    let checkout = { [unowned self] in self.checkout() }
    let checkoutViewController = CheckoutViewController(checkout: checkout)
    let checkoutNavigationController = UINavigationController(rootViewController: checkoutViewController)
    let checkoutImage = UIImage(named: "for-you")
    let checkoutTabBarItem = UITabBarItem(title: "Swift Checkout", image: checkoutImage, selectedImage: nil)
    checkoutNavigationController.tabBarItem = checkoutTabBarItem

    let objcCheckoutViewController = ObjcCheckoutViewController { callback in
      checkoutUrlProvider(Settings.email) { result in
        switch result {
        case .success(let url): callback(url, nil)
        case .failure(let error): callback(nil, error)
        }
      }
    }

    let objcCheckoutNavigationController = UINavigationController(rootViewController: objcCheckoutViewController)
    let objcCheckoutTabBarItem = UITabBarItem(title: "Objc Checkout", image: checkoutImage, selectedImage: nil)
    objcCheckoutNavigationController.tabBarItem = objcCheckoutTabBarItem

    let settings = [Settings.$email, Settings.$host, Settings.$port]
    let settingsViewController = SettingsViewController(settings: settings)
    let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
    let settingsImage = UIImage(named: "settings")
    let settingsTabBarItem = UITabBarItem(title: "Settings", image: settingsImage, selectedImage: nil)
    settingsNavigationController.tabBarItem = settingsTabBarItem

    let viewControllers = [
      checkoutNavigationController,
      objcCheckoutNavigationController,
      settingsNavigationController,
    ]

    ownedTabBarController.setViewControllers(viewControllers, animated: false)
  }

  override func loadView() {
    view = UIView()

    install(ownedTabBarController)
  }

  // MARK: Checkout

  private func checkout() {
    let presentCheckout = { [unowned self] checkoutUrl in
      Afterpay.presentCheckout(
        over: self,
        loading: checkoutUrl,
        cancelHandler: {
        },
        successHandler: { token in
        }
      )
    }

    let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

    let presentAlert = { [unowned self] (message: String) in
      alert.message = message
      self.present(alert, animated: true, completion: nil)
    }

    checkoutUrlProvider(Settings.email) { result in
      switch result {
      case .success(let url):
        DispatchQueue.main.async { presentCheckout(url) }
      case .failure(CheckoutError.malformedUrl):
        presentAlert("Invalid host and port settings")
      case .failure:
        DispatchQueue.main.async { presentAlert("Failed to retrieve checkout url") }
      }
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
