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
    URL(string: "http://localhost:8000/widget-bootstrap.html")!
  }

  var widgetScriptURL: URL {
    URL(string: "https://portal.sandbox.afterpay.com/afterpay.js")!
  }

  var bootstrapCacheDisplayName: String { "afterpay.com" }

}
