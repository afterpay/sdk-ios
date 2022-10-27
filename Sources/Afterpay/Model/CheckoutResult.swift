//
//  CheckoutResult.swift
//  Afterpay
//
//  Created by Adam Campbell on 29/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

@frozen public enum CheckoutResult {
  case success(token: String)
  case cancelled(reason: CancellationReason)

  public enum CancellationReason {
    case userInitiated
    case unretrievableUrl
    case networkError(Error)
    case invalidURL(URL)
  }
}
