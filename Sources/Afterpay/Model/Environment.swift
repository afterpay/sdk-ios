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

  var widgetScriptURL: URL {
    /*
    The `merchant_key` parameter is deprecated. It will be removed in a later version of `afterpay.js`.
    The value `demo` is sufficient until then.
    */
    URL(string: "https://portal.sandbox.afterpay.com/afterpay.js?merchant_key=demo")!
  }

  var bootstrapCacheDisplayName: String { "afterpay.com" }

}
