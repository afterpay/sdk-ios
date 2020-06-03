//
//  SceneDelegate.swift
//  Example
//
//  Created by Adam Campbell on 3/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        window = UIWindow(windowScene: scene as! UIWindowScene)
        window?.rootViewController = UIHostingController(rootView: ContentView())
        window?.makeKeyAndVisible()
    }

}
