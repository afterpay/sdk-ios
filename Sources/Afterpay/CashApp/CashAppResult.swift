//
//  CashAppResult.swift
//  Afterpay
//
//  Created by Scott Antonac on 11/1/2023.
//  Copyright © 2023 Afterpay. All rights reserved.
//

import Foundation

@frozen public enum CashAppResult {
  case success(data: CashAppData)
  case cancelled(reason: CashAppCancellationReason)

  public enum CashAppCancellationReason {
    case invalidAmount
    case invalidRedirectUrl
    case jwtDecodeNullError
    case jwtDecodeError(error: Error)
    case httpError(errorCode: Int)
    case error(error: Error)
  }
}

public struct CashAppData {
  public var amount: UInt
  public var redirectUri: URL
  public var merchantId: String
  public var brandId: String
}
