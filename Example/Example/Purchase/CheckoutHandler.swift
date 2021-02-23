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

  private var checkoutTokenResultCompletion: CheckoutTokenResultCompletion?
  private var shippingOptionsCompletion: ShippingOptionsCompletion?

  init(
    didCommenceCheckout: @escaping () -> Void,
    onShippingAddressDidChange: @escaping (ShippingAddress) -> Void
  ) {
    didCommenceCheckoutClosure = didCommenceCheckout
    onShippingAddressDidChangeClosure = onShippingAddressDidChange
  }

  func didCommenceCheckout(completion: @escaping CheckoutTokenResultCompletion) {
    checkoutTokenResultCompletion = completion
    didCommenceCheckoutClosure()
  }

  func provideTokenResult(tokenResult: Result<Token, Error>) {
    checkoutTokenResultCompletion?(tokenResult)
    checkoutTokenResultCompletion = nil
  }

  func shippingAddressDidChange(address: ShippingAddress, completion: @escaping ShippingOptionsCompletion) {
    shippingOptionsCompletion = completion
    onShippingAddressDidChangeClosure(address)
  }

  func provideShippingOptions(shippingOptions: [ShippingOption]) {
    shippingOptionsCompletion?(.success(shippingOptions))
    shippingOptionsCompletion = nil
  }

  func shippingOptionDidChange(shippingOption: ShippingOption) {}

}
