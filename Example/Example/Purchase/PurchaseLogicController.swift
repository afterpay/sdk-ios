//
//  PurchaseLogicController.swift
//  Example
//
//  Created by Adam Campbell on 1/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

final class PurchaseLogicController {

  typealias CheckoutURLProvider = (
    _ email: String,
    _ completion: @escaping (Result<URL, Error>) -> Void
  ) -> Void

  typealias PurchaseStateHandler = (PurchaseState) -> Void

  private struct State {
    var current: PurchaseState { purchaseState }

    private var purchaseState: PurchaseState = .initial
    private var handler: PurchaseStateHandler = { _ in }

    mutating func update(state: PurchaseState) {
      purchaseState = state
      handler(state)
    }

    mutating func set(handler: @escaping PurchaseStateHandler) {
      handler(purchaseState)
      self.handler = handler
    }
  }

  private let checkoutURLProvider: CheckoutURLProvider
  private var state = State()

  init(checkoutURLProvider: @escaping CheckoutURLProvider) {
    self.checkoutURLProvider = checkoutURLProvider
  }

  func setStateHandler(stateHandler: @escaping PurchaseStateHandler) {
    state.set(handler: stateHandler)
  }

}
