//
//  Features.swift
//  Afterpay
//
//  Created by Huw Rowlands on 11/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

struct Features {

  /// Is the checkout widget enabled?
  static var widgetEnabled: Bool {
    UserDefaults.standard.bool(forKey: "com.afterpay.widget-enabled")
  }

}
