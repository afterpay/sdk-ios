//
//  AfterpayBundleFinder.swift
//  Afterpay
//
//  Created by Scott Antonac on 6/4/2022.
//  Copyright © 2022 Afterpay. All rights reserved.
//

import Foundation

private class AfterpayBundleFinder {}

internal extension Foundation.Bundle {

  /**
  The resource bundle associated with the current module..
  - important: When `Afterpay` is distributed via Swift Package Manager,
  it will be synthesized automatically in the name of `Bundle.module`.
  */
  static var apResource: Bundle = {
    let moduleName = "Afterpay"
    #if COCOAPODS
      let bundleName = moduleName
    #else
      let bundleName = "\(moduleName)_\(moduleName)"
    #endif

    let candidates = [
      // Bundle should be present here when the package is linked into an App.
      Bundle.main.resourceURL,

      // Bundle should be present here when the package is linked into a framework.
      Bundle(for: AfterpayBundleFinder.self).resourceURL,

      // For command-line tools.
      Bundle.main.bundleURL,
    ]

    for candidate in candidates {
      let bundlePath = candidate?.appendingPathComponent(bundleName + ".bundle")
      if let bundle = bundlePath.flatMap(Bundle.init(url:)) {
        return bundle
      }
    }

    return Bundle(for: AfterpayBundleFinder.self)
  }()
}
