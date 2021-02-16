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

    let purchaseLogicController = PurchaseLogicController(
      checkoutResponseProvider: Repository.shared.checkout,
      email: Settings.email,
      currencyCode: Settings.currencyCode
    )

    let purchase = PurchaseFlowController(logicController: purchaseLogicController)
    purchase.tabBarItem = UITabBarItem(
      title: "Purchase",
      image: UIImage(named: "briefcase"),
      selectedImage: nil)

    let components = ComponentsViewController()
    components.tabBarItem = UITabBarItem(
      title: "Components",
      image: UIImage(named: "for-you"),
      selectedImage: nil)

    let settings = UINavigationController(
      rootViewController: SettingsViewController(settings: AppSetting.allSettings))
    settings.tabBarItem = UITabBarItem(
      title: "Settings",
      image: UIImage(named: "settings"),
      selectedImage: nil)

    ownedTabBarController.setViewControllers([purchase, components, settings], animated: false)
  }

  override func loadView() {
    self.view = UIView()
    install(ownedTabBarController)
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
