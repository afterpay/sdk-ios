//
//  ViewController.swift
//  Example
//
//  Created by Adam Campbell on 12/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import SwiftUI
import TrustKit
import UIKit

final class AppFlowController: UIViewController {

  private let dependencies = Dependencies()
  private let ownedTabBarController = UITabBarController()

  init() {
    super.init(nibName: nil, bundle: nil)

    let purchaseLogicController = PurchaseLogicController(
      checkoutURLProvider: checkout,
      email: Settings.email,
      currencyCode: Settings.currencyCode
    )

    let purchase = PurchaseFlowController(logicController: purchaseLogicController)
    purchase.tabBarItem = UITabBarItem(
      title: "Purchase",
      image: UIImage(named: "for-you"),
      selectedImage: nil)

    let settings = UINavigationController(
      rootViewController: SettingsViewController(settings: AppSetting.allSettings))
    settings.tabBarItem = UITabBarItem(
      title: "Settings",
      image: UIImage(named: "settings"),
      selectedImage: nil)

    ownedTabBarController.setViewControllers([purchase, settings], animated: false)
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
