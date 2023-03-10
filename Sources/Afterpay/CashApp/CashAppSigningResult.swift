//
//  CashAppResult.swift
//  Afterpay
//
//  Created by Scott Antonac on 11/1/2023.
//  Copyright © 2023 Afterpay. All rights reserved.
//

import Foundation

@frozen public enum CashAppSigningResult {
  case success(data: CashAppSigningData)
  case failed(reason: CashAppSigningCancellationReason)

  public enum CashAppSigningCancellationReason {
    case invalidAmount
    case invalidRedirectUrl
    case jwtDecodeNullError
    case responseDecodeError
    case jwtDecodeError(error: Error)
    case httpError(errorCode: Int)
    case error(error: Error)
  }
}

public struct CashAppSigningData {
  public var jwt: String
  public var amount: UInt
  public var redirectUri: URL
  public var merchantId: String
  public var brandId: String
}

@frozen public enum CashAppValidationResult {
  case success(data: CashAppValidationData)
  case failed(reason: CashAppValidationCancellationReason)

  public enum CashAppValidationCancellationReason {
    case nilData
    case responseDecodeError
    case unknownError
    case invalid
    case httpError(errorCode: Int, message: String)
    case error(error: Error)
  }
}

public struct CashAppValidationData: Decodable {
  public var cashAppTag: String
  public var status: String
  public var callbackBaseUrl: String
}
