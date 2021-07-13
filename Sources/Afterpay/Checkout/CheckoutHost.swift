//
//  CheckoutHost.swift
//  Afterpay
//
//  Created by Adam Campbell on 23/11/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

enum CheckoutHost: String, CaseIterable {

  static let validSet = Set<String>(allCases.map(\.rawValue))

  case afterpay = "portal.afterpay.com"
  case afterpaySandbox = "portal.sandbox.afterpay.com"
  case afterpayPlusSandbox = "api-plus.us-sandbox.afterpay.com"
  case afterpayPlus = "api-plus.us.afterpay.com"
  case clearpay = "portal.clearpay.co.uk"
  case clearpaySandbox = "portal.sandbox.clearpay.co.uk"

}
