//
//  ViewController.swift
//  Example
//
//  Created by Adam Campbell on 12/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

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

    let checkoutFlowController = CheckoutFlowController()
    let checkoutImage = UIImage(named: "for-you")
    let checkoutTabBarItem = UITabBarItem(title: "Checkout", image: checkoutImage, selectedImage: nil)
    checkoutFlowController.tabBarItem = checkoutTabBarItem

    let settings = [Settings.$email, Settings.$host, Settings.$port]
    let settingsViewController = SettingsViewController(settings: settings)
    let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
    let settingsImage = UIImage(named: "settings")
    let settingsTabBarItem = UITabBarItem(title: "Settings", image: settingsImage, selectedImage: nil)
    settingsNavigationController.tabBarItem = settingsTabBarItem

    let viewControllers = [checkoutFlowController, settingsNavigationController]

    ownedTabBarController.setViewControllers(viewControllers, animated: false)
  }

  override func loadView() {
    let containerView = UIView()
    install(ownedTabBarController, into: containerView)
    view = containerView
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
