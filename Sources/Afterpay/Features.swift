//
//  Features.swift
//  Afterpay
//
//  Created by Huw Rowlands on 11/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public struct AfterpayFeatures {

  /// Is the checkout widget enabled?
  ///
  /// Enable by setting '`-com.afterpay.widget-enabled YES`' argument on launch.
  public static var widgetEnabled: Bool {
    UserDefaults.standard.bool(forKey: "com.afterpay.widget-enabled")
  }

}
