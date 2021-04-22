//
//  Environment.swift
//  Afterpay
//
//  Created by Adam Campbell on 2/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

@frozen public enum Environment: String {

  case sandbox
  case production

  var checkoutBootstrapURL: URL {
    URL(string: "https://static.afterpay.com/mobile-sdk/bootstrap/index.html")!
  }

  var widgetBootstrapURL: URL {
    URL(string: "https://afterpay.github.io/sdk-example-server/widget-bootstrap.html")!
  }

  var bootstrapCacheDisplayName: String { "afterpay.com" }

}
