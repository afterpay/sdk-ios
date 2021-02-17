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

  var bootstrapURL: URL {
    URL(string: "https://static.afterpay.com/mobile-sdk/bootstrap/index.html")!
  }
}
