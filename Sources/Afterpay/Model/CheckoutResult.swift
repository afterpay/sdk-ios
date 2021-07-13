//
//  CheckoutResult.swift
//  Afterpay
//
//  Created by Adam Campbell on 29/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

@frozen public enum CheckoutResult {
  case success(value: Value)
  case cancelled(reason: CancellationReason)

  @frozen public enum Value {
    case token(token: String)
    case singleUseCard(authToken: String, cardValidUntil: Date?, details: CardDetails)
  }

  public enum CancellationReason {
    case userInitiated
    case networkError(Error)
    case invalidURL(URL)
  }
}
