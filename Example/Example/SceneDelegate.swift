//
//  SceneDelegate.swift
//  Example
//
//  Created by Adam Campbell on 3/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    // As per the scene configuration in AppDelegate a force cast is 'safe' here
    // swiftlint:disable:next force_cast
    window = UIWindow(windowScene: scene as! UIWindowScene)
    window?.rootViewController = PaymentFlowController()
    window?.makeKeyAndVisible()
  }

}
