//
//  CheckoutResult.swift
//  Afterpay
//
//  Created by Adam Campbell on 29/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

@frozen public enum SingleUseCardCheckoutResult {
  case success(virtualCard: VirtualCard)
  case failed(reason: SingleUseCardFailureReason)

  public enum SingleUseCardFailureReason {
    case apiError(APIPlusErrorDetails)
    case networkError(Error)
    case checkoutCancelled(reason: CheckoutResult.CancellationReason)
  }
}
