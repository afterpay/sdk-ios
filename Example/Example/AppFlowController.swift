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

  private let ownedTabBarController = UITabBarController()

  init() {
    super.init(nibName: nil, bundle: nil)

    let purchaseLogicController = PurchaseLogicController(checkoutURLProvider: checkout)
    let purchaseFlowController = PurchaseFlowController(logicController: purchaseLogicController)
    let purchaseImage = UIImage(named: "for-you")
    let checkoutTabBarItem = UITabBarItem(title: "Purchase", image: purchaseImage, selectedImage: nil)
    purchaseFlowController.tabBarItem = checkoutTabBarItem

    let settings = [Settings.$email, Settings.$host, Settings.$port, Settings.$currencyCode]
    let settingsViewController = SettingsViewController(settings: settings)
    let settingsNavigationController = UINavigationController(rootViewController: settingsViewController)
    let settingsImage = UIImage(named: "settings")
    let settingsTabBarItem = UITabBarItem(title: "Settings", image: settingsImage, selectedImage: nil)
    settingsNavigationController.tabBarItem = settingsTabBarItem

    let viewControllers = [purchaseFlowController, settingsNavigationController]

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
