//
//  OSLog+Afterpay.swift
//  Afterpay
//
//  Created by Adam Campbell on 24/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import os.log

private final class BundleTag {}

extension OSLog {

  private static let subsystem = Bundle(for: BundleTag.self).bundleIdentifier!

  static let checkout = OSLog(subsystem: subsystem, category: "checkout")

}
