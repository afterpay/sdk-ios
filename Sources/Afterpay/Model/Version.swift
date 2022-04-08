//
//  Version.swift
//  Afterpay
//
//  Created by Adam Campbell on 9/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

final class Version {
  private static let bundle = Bundle.apResource

  static let shortVersion = bundle.infoDictionary!["CFBundleShortVersionString"] as! String
  static let sdkVersion = shortVersion + "-ios"
}
