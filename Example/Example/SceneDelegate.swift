//
//  SceneDelegate.swift
//  Example
//
//  Created by Adam Campbell on 3/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import UIKit
import PayKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate, WindowHolder {

  var window: UIWindow?

  func scene(
    _ scene: UIScene,
    willConnectTo session: UISceneSession,
    options connectionOptions: UIScene.ConnectionOptions
  ) {
    install(window: UIWindow(windowScene: scene as! UIWindowScene))

    #if DEBUG
    if CommandLine.arguments.contains("-disableAnimations") {
      window?.layer.speed = 4.0
    }
    #endif

  }

  func scene(
    _ scene: UIScene,
    openURLContexts URLContexts: Set<UIOpenURLContext>
  ) {
    if let url = URLContexts.first?.url {
      NotificationCenter.default.post(
        name: PayKit.RedirectNotification,
        object: nil,
        userInfo: [UIApplication.LaunchOptionsKey.url: url]
      )
    }
  }

}
