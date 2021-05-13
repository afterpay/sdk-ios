//
//  CheckoutHandler.swift
//  Example
//
//  Created by Adam Campbell on 16/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Afterpay
import Foundation

final class CheckoutHandler: CheckoutV2Handler {

  private let didCommenceCheckoutClosure: () -> Void
  private let onShippingAddressDidChangeClosure: (ShippingAddress) -> Void

  private var checkoutTokenResultCompletion: TokenResultCompletion?
  private var shippingOptionsCompletion: ShippingOptionsCompletion?

  init(
    didCommenceCheckout: @escaping () -> Void,
    onShippingAddressDidChange: @escaping (ShippingAddress) -> Void
  ) {
    didCommenceCheckoutClosure = didCommenceCheckout
    onShippingAddressDidChangeClosure = onShippingAddressDidChange
  }

  func didCommenceCheckout(completion: @escaping TokenResultCompletion) {
    checkoutTokenResultCompletion = completion
    didCommenceCheckoutClosure()
  }

  func provideTokenResult(tokenResult: TokenResult) {
    checkoutTokenResultCompletion?(tokenResult)
    checkoutTokenResultCompletion = nil
  }

  func shippingAddressDidChange(
    address: ShippingAddress,
    completion: @escaping ShippingOptionsCompletion
  ) {
    shippingOptionsCompletion = completion
    onShippingAddressDidChangeClosure(address)
  }

  func provideShippingOptionsResult(result shippingOptionsResult: ShippingOptionsResult) {
    shippingOptionsCompletion?(shippingOptionsResult)
    shippingOptionsCompletion = nil
  }

  func shippingOptionDidChange(shippingOption: ShippingOption) {}

}
