//
//  CheckoutV3CashAppPayResult.swift
//  Afterpay
//
//  Created by Mark Mroz on 2024-05-31.
//  Copyright © 2024 Afterpay. All rights reserved.
//

import Foundation

public struct CheckoutV3CashAppPayPayload {
  public let token: Token
  public let singleUseCardToken: String
  public let cashAppSigningData: CashAppSigningData
}

@frozen public enum CheckoutV3CashAppPayResult {
  case success(data: CheckoutV3CashAppPayPayload)
  case cancelled(reason: CashAppSigningResult.CashAppSigningCancellationReason)
  case failure(error: Error)
}
