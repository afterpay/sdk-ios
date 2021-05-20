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

  var widgetBootstrapScriptURL: URL {
    switch self {
    case .sandbox:
      return URL(string: "https://afterpay.github.io/sdk-example-server/widget-bootstrap.js")!
    case .production:
      return URL(string: "https://static.afterpay.com/mobile-sdk/bootstrap/widget-bootstrap.js")!
    }
  }

  var afterpayJsURL: String {
    switch self {
    case .sandbox:
      return "https://portal.sandbox.afterpay.com/afterpay.js?merchant_key=demo"
    case .production:
      return "https://portal.afterpay.com/afterpay.js?merchant_key=demo"
    }
  }

  var bootstrapCacheDisplayName: String { "afterpay.com" }

  var widgetBootstrapHTML: String {
    """
    <html>
      <head>
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">

        <script src="\(afterpayJsURL)"></script>

        \(bootstrapScript)
      </head>
      <body>
        <div id="afterpay-widget-container" style="margin: 16px 0px"></div>
      </body>
    </html>
    """
  }

  private var bootstrapScript: String {
    if AfterpayFeatures.mockWidgetBootstrap {
      let realUrl = Bundle(for: WidgetView.self).url(forResource: "mock-widget-bootstrap", withExtension: "js")!
      let script = try? String(contentsOf: realUrl)
      return #"<script>\#(script ?? "")</script>"#
    }

    return #"<script src="\#(widgetBootstrapScriptURL.absoluteString)"></script>"#
  }

}
