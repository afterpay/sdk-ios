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

  typealias StateHandler = (PurchaseState) -> Void

  private struct State {
    var current: PurchaseState { purchaseState }
    var handler: StateHandler = { _ in }

    private var purchaseState: PurchaseState = .initial

    mutating func update(state: PurchaseState) {
      purchaseState = state
      handler(state)
    }
  }

  private let checkoutURLProvider: CheckoutURLProvider
  private var state = State()

  init(checkoutURLProvider: @escaping CheckoutURLProvider) {
    self.checkoutURLProvider = checkoutURLProvider
  }

  func setStateHandler(stateHandler: @escaping StateHandler) {
    stateHandler(state.current)
    state.handler = stateHandler
  }

}
