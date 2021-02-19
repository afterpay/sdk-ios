//
//  APIErrorDetails.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 19/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public enum APIError: Error {
  case error(details: APIErrorDetails)
}

public struct APIErrorDetails: Decodable {
  public let errorCode: String
  public let errorId: String
  public let message: String
  public let httpStatusCode: Int
}
