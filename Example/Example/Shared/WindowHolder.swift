//
//  WindowHolder.swift
//  Example
//
//  Created by Adam Campbell on 22/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

protocol WindowHolder: AnyObject {
  var window: UIWindow? { get set }
}

extension WindowHolder {
  func install(window: UIWindow) {
    window.rootViewController = AppFlowController(checkoutUrlProvider: checkout)
    window.makeKeyAndVisible()

    self.window = window
  }
}
