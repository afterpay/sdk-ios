//
//  SingleUseCardLogicController.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 26/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import os.log

final class SingleUseCardLogicController {
  typealias CheckoutCancelReason = CheckoutResult.CancellationReason

  enum Screen: Equatable {
    case initialAmount(value: String)
    case editAmount(value: String)
    case singleUseCard
    case checkout(url: URL)
    case info
    case cancel
    case loading
  }

  enum Command {
    case navigate(fromScreen: Screen, toScreen: Screen)
    case handleError(Error)
    case dismissOnCardCancellation
    case showEditCancelActionSheet
    case dismissModalOnSuccess(VirtualCard)
    case cancelWebCheckout(reason: CheckoutCancelReason)
  }

  // Payload for consumer cards API request
  private var singleUseCardRequest: SingleUseCardCreateRequest
  private var virtualCard: VirtualCard?
  private var cardExpiry: String?
  private var checkoutToken: String?
  private var singleUseCardToken: String?

  private var currentScreen: Screen {
    didSet {
      commandHandler(.navigate(fromScreen: oldValue, toScreen: currentScreen))
    }
  }

  var amount: Money {
    return singleUseCardRequest.amount
  }
  var merchantName: String {
    return singleUseCardRequest.merchant.name
  }
  var singleUseCard: (virtualCard: VirtualCard?, expiry: String?) {
    return (virtualCard, cardExpiry)
  }

  let aggregatorName: String
  let mode: Mode

  private var commandHandler: (Command) -> Void = { _ in }

  init(
    with singleUseCardRequest: SingleUseCardCreateRequest,
    mode: Mode,
    aggregatorName: String
  ) {
    self.singleUseCardRequest = singleUseCardRequest
    self.mode = mode
    self.aggregatorName = aggregatorName
    self.currentScreen = .initialAmount(value: singleUseCardRequest.amount.amount)
  }

  func configureCommandHandler(with handler: @escaping (Command) -> Void) {
    commandHandler = handler
  }

  func navigateToCurrentScreen() {
    commandHandler(.navigate(fromScreen: currentScreen, toScreen: currentScreen))
  }

  func checkoutSuccess(checkoutToken: String) {
    self.checkoutToken = checkoutToken
    currentScreen = .loading
    callCardConfirmAPI()
    currentScreen = .loading
  }

  func checkoutCancel(reason: CheckoutCancelReason) {
    commandHandler(.cancelWebCheckout(reason: reason))

    if virtualCard == nil {
      currentScreen = .initialAmount(value: amount.amount)
    } else {
      currentScreen = .editAmount(value: amount.amount)
    }
  }

  func showInfoPage() {
    currentScreen = .info
  }

  func confirmCardCancellation() {
    currentScreen = .loading
    callCardCancelAPI()
  }

  func showEditCancelOptions() {
    commandHandler(.showEditCancelActionSheet)
  }

  func loadCheckout(amountValue: String) {
    singleUseCardRequest.amount = Money(amount: amountValue, currency: singleUseCardRequest.amount.currency)
    currentScreen = .loading

    callCardCreateAPI()
  }

  func dismissModal() {
    if case .singleUseCard = currentScreen, let card = virtualCard {
      commandHandler(.dismissModalOnSuccess(card))
    }
  }

  // TODO: Cancel current card and create new one
  func showEditCardScreen() {
    currentScreen = .editAmount(value: singleUseCardRequest.amount.amount)
  }

  func showCancelCardScreen() {
    currentScreen = .cancel
  }

  // MARK: - API Response handlers

  private func handleCreateCardSuccess(_ response: SingleUseCardCreateResponse) {
    singleUseCardToken = response.consumerCardToken
    cardExpiry = response.expires
    self.currentScreen = .checkout(url: response.redirectCheckoutUrl)
  }

  private func handleConfirmCardSucces(_ response: SingleUseCardConfirmResponse) {
    virtualCard = response.paymentDetails.virtualCard
    self.currentScreen = .singleUseCard
  }

  private func handleCancelCardSuccess() {
    self.commandHandler(.dismissOnCardCancellation)
  }

  // MARK: - API Calls

  func callCardCreateAPI() {
    APIPlusNetworkService.shared.request(
      endpoint: .singleUseCards(singleUseCardRequest),
      mode: mode
    ) { [weak self] (result: Result<SingleUseCardCreateResponse, Error>) in
      result.fold(
        successTransform: { response in
          self?.handleCreateCardSuccess(response)
        },
        errorTransform: { error in
          self?.commandHandler(.handleError(error))
        }
      )
    }
  }

  func callCardConfirmAPI() {
    guard
      let singleUseCardToken = singleUseCardToken,
      let checkoutToken = checkoutToken
    else {
      os_log("checkoutToken and cardToken are required", log: .singleUseCard, type: .debug)
      return
    }

    let payload = SingleUseCardConfirmRequest(
      consumerCardToken: singleUseCardToken,
      token: checkoutToken,
      aggregator: singleUseCardRequest.aggregator
    )

    APIPlusNetworkService.shared.request(
      endpoint: .singleUseCardConfirm(payload),
      mode: mode
    ) { [weak self] (result: Result<SingleUseCardConfirmResponse, Error>) in
      result.fold(
        successTransform: { response in
          self?.handleConfirmCardSucces(response)
        },
        errorTransform: { error in
          self?.commandHandler(.handleError(error))
        }
      )
    }
  }

  // TODO: Handle when cancelling card fails
  private func callCardCancelAPI() {
    guard
      let singleUseCardToken = singleUseCardToken,
      let checkoutToken = checkoutToken
    else {
      os_log("checkoutToken and cardToken are required", log: .singleUseCard, type: .debug)
      return
    }

    // TODO: Replace hardcoded aggregator name
    let payload = SingleUseCardCancelRequest(
      consumerCardToken: singleUseCardToken,
      token: checkoutToken,
      aggregator: "deadbeef"
    )

    APIPlusNetworkService.shared.request(
      endpoint: .singleUseCardCancel(payload),
      mode: mode
    ) { [weak self] result in
      result.fold(
        successTransform: { _ in self?.handleCancelCardSuccess() },
        errorTransform: { error in
          self?.commandHandler(.handleError(error))
        }
      )
    }
  }
}
