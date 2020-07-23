//
//  AppDelegate.swift
//  Example
//
//  Created by Adam Campbell on 3/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, WindowHolder {

  var window: UIWindow?

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    initializeDependencies()

    if #available(iOS 13.0, *) {
      // Window installation handled by SceneDelegate
    } else {
      install(window: UIWindow(frame: UIScreen.main.bounds))
    }

    return true
  }

  @available(iOS 13.0, *)
  func application(
    _ application: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    let configuration = UISceneConfiguration(name: nil, sessionRole: .windowApplication)
    configuration.delegateClass = SceneDelegate.self
    configuration.sceneClass = UIWindowScene.self

    return configuration
  }

}
