//
//  Endpoint.swift
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
  case singleUseCards(SingleUseCardRequest)
  case singleUseCardConfirm(SingleUseCardConfirmRequest)
}

extension Endpoint {
  func baseURL(mode: Mode = .sandbox) -> String {
    switch mode {
    case .sandbox:
      return "https://api-plus-single-use-cards.us-sandbox.afterpay.com"
    case .production:
      return "https://api-plus.us.afterpay.com"
    }
  }

  var path: String {
    switch self {
    case .singleUseCards:
      return "/v2/consumer_cards"
    case .singleUseCardConfirm:
      return "/v2/consumer_cards/confirm"
    }
  }

  var method: RequestMethod {
    switch self {
    case .singleUseCards, .singleUseCardConfirm:
      return .post
    }
  }
}
