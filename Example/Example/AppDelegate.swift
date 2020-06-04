//
//  AppDelegate.swift
//  Example
//
//  Created by Adam Campbell on 3/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return true
  }

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
