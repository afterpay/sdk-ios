//
//  EndPoint.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 11/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

enum RequestMethod: String {
  case get = "GET"
  case post = "POST"
}

enum Endpoint {
  case consumerCards(ConsumerCardRequest)
  case consumerCardConfirm(ConsumerCardConfirmRequest)
}

extension Endpoint {
  func baseURL(mode: Mode = .sandbox) -> String {
    switch mode {
    case .sandbox:
      return "https://api-plus.us-sandbox.afterpay.com"
    case .production:
      return "https://api-plus.us.afterpay.com"
    }
  }

  var path: String {
    switch self {
    case .consumerCards:
      return "/v2/consumer_cards"
    case .consumerCardConfirm:
      return "/v2/consumer_cards/confirm"
    }
  }

  var method: RequestMethod {
    switch self {
    case .consumerCards, .consumerCardConfirm:
      return .post
    }
  }
}
