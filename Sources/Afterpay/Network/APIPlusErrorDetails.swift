//
//  APIErrorDetails.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 19/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public enum APIPlusError: Error {
  case error(details: APIPlusErrorDetails)
}

public struct APIPlusErrorDetails: Decodable, Equatable {
  public let errorCode: String
  public let errorId: String
  public let message: String
  public let httpStatusCode: Int

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return lhs.errorCode == rhs.errorCode &&
    lhs.errorId == rhs.errorId &&
    lhs.message == rhs.message &&
    lhs.httpStatusCode == rhs.httpStatusCode
  }
}
