//
//  WKWebView+UserAgent.swift
//  Afterpay
//
//  Created by Huw Rowlands on 7/5/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import WebKit

extension WKWebViewConfiguration {

  static let appNameForUserAgent = "Afterpay-iOS-SDK/\(Version.shortVersion)"

}
