//
//  CheckoutCashAppHandler.swift
//  Example
//
//  Created by Scott Antonac on 7/12/2022.
//  Copyright © 2022 Afterpay. All rights reserved.
//

import Afterpay
import Foundation

final class CheckoutCashAppHandler: CashAppPayCheckoutHandler {
  private let didCommenceCheckoutClosure: () -> Void

  private var checkoutTokenResultCompletion: TokenResultCompletion?

  init(didCommenceCheckout: @escaping () -> Void) {
    didCommenceCheckoutClosure = didCommenceCheckout
  }

  func didCommenceCheckout(completion: @escaping Afterpay.TokenResultCompletion) {
    checkoutTokenResultCompletion = completion
    didCommenceCheckoutClosure()
  }

  func provideTokenResult(tokenResult: TokenResult) {
    checkoutTokenResultCompletion?(tokenResult)
    checkoutTokenResultCompletion = nil
  }
}
