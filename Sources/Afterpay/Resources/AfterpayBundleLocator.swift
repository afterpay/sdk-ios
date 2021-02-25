//
//  AfterpayBundleLocator.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 25/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

class AfterpayBundleLocator: NSObject {
  
  // Currently only locates bundle for SPM and manual integration
  static var resourceBundle: Bundle = {
    var packageBundle: Bundle?
    
    #if SWIFT_PACKAGE
    packageBundle = Bundle.module
    #endif
    
    if let packageBundle = packageBundle {
      return packageBundle
    } else {
      guard let bundle = Bundle(identifier: "com.afterpay.Afterpay") else {
        return Bundle.main
      }
      
      return bundle
    }
  }()
}
