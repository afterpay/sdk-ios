//
//  CheckoutResult.swift
//  Afterpay
//
//  Created by Adam Campbell on 29/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

@frozen public enum ConsumerCardCheckoutResult {
  case success(virtualCard: VirtualCard)
  case failed(error: ConsumerCardError)

  // TODO: Handle error
  public enum ConsumerCardError {
    case networkError(Error)
  }
}
