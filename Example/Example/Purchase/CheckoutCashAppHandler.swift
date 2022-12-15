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

  func stateDidChange(to state: String) {}

  func provideTokenResult(tokenResult: TokenResult) {
//    let checkout = CheckoutCashAppPay(tokenResult: tokenResult)
//    checkout.commenceCheckout()

    print("hello", tokenResult)

    checkoutTokenResultCompletion?(tokenResult)
    checkoutTokenResultCompletion = nil
  }
}
