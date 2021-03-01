//
//  AfterpayBundleLocator.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 25/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

final class AfterpayBundleLocator: NSObject {

  static var resourceBundle: Bundle = {
    var packageBundle: Bundle?

    // Bundle for SPM
    #if SWIFT_PACKAGE
    packageBundle = Bundle.module
    #endif

    // Bundle for Cocoapods with static linking
    // TODO: Configure .resource_bundles in the podspec
    if packageBundle == nil {
      packageBundle = Bundle(path: "Afterpay.bundle")
    }

    // Bundle for Cocoapods with dynamic linking
    // This will locate a bundle under Afterpay.framework/Afterpay.bundle
    // TODO: Configure .resource_bundles in the podspec
    if packageBundle == nil {
      if let path = Bundle(for: AfterpayBundleLocator.self).path(
        forResource: "Afterpay", ofType: "bundle") {
        packageBundle = Bundle(path: path)
      }
    }

    // Look for package in Afterpay.Framework for Carthage or manual dynamic installation
    if packageBundle == nil {
      packageBundle = Bundle(for: AfterpayBundleLocator.self)
    }

    // Return the bundle or else return Bundle.main if package is dragged and drop to the project
    if let packageBundle = packageBundle {
      return packageBundle
    } else {
      return Bundle.main
    }
  }()
}
