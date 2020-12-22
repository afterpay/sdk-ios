//
//  InteractiveCheckoutCompletion.swift
//  Afterpay
//
//  Created by Adam Campbell on 9/12/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

enum InteractiveCheckoutCompletion: Decodable {

  case success(token: String)
  case cancelled

  private enum CodingKeys: String, CodingKey {
    case status
    case orderToken
  }

  private enum Status: String {
    case success = "SUCCESS"
    case cancelled = "CANCELLED"
  }

  private enum DecodingError: Error {
    case invalidStatus
  }

  init?(url: URL) {
    let queryItems = URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
    let status = queryItems?
      .first(where: { $0.name == CodingKeys.status.rawValue })?.value
      .map(Status.init(rawValue:))
    let token = queryItems?
      .first(where: { $0.name == CodingKeys.orderToken.rawValue })?.value

    switch (status, token) {
    case (.success, let token?):
      self = .success(token: token)
    case (.cancelled, _):
      self = .cancelled
    default:
      return nil
    }
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let status = try container.decode(String.self, forKey: .status)

    switch Status(rawValue: status) {
    case .success:
      let token = try container.decode(String.self, forKey: .orderToken)
      self = .success(token: token)
    case .cancelled:
      self = .cancelled
    case .none:
      throw DecodingError.invalidStatus
    }
  }

}
