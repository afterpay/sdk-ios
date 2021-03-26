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
  enum Screen: Equatable {
    case initialAmount(value: String)
    case editAmount(value: String)
    case singleUseCard
    case checkout
    case info
    case cancel
    case loading
  }

  enum Command {
    case navigateTo(screen: Screen)
    case handleError(Error)
    case dismissOnCardCancellation
    case showEditCancelActionSheet
    case dismissModalOnSuccess(VirtualCard)
  }

  // Payload for consumer cards API request
  private var singleUseCardRequest: SingleUseCardCreateRequest
  private var virtualCard: VirtualCard?
  private var checkoutToken: String?
  private var singleUseCardToken: String?

  var currentScreen: Screen {
    didSet {
      commandHandler(.navigateTo(screen: currentScreen))
    }
  }

  let aggregatorName: String
  private let mode: Mode

  private let commandHandler: (Command) -> Void

  init(
    with singleUseCardRequest: SingleUseCardCreateRequest,
    mode: Mode,
    aggregatorName: String,
    commandHandler: @escaping (Command) -> Void
  ) {
    self.singleUseCardRequest = singleUseCardRequest
    self.mode = mode
    self.aggregatorName = aggregatorName
    self.commandHandler = commandHandler
    self.currentScreen = .initialAmount(value: singleUseCardRequest.amount.amount)
  }

  func showInfoPage() {
    currentScreen = .info
  }

  func confirmCardCancellation() {
    currentScreen = .loading
    callSingleUseCardCancelAPI()
  }

  func showEditCancelOptions() {
    commandHandler(.showEditCancelActionSheet)
  }

  func loadCheckout(amountValue: String) {
    singleUseCardRequest.amount = Money(amount: amountValue, currency: singleUseCardRequest.amount.currency)
    currentScreen = .loading

    callSingleUseCardCreateAPI()
  }

  func dismissModal() {
    if case .singleUseCard = currentScreen,
       let card = virtualCard {
      commandHandler(.dismissModalOnSuccess(card))
    }
  }

  // MARK: - API Response handlers

  private func handleCreateCardSuccess(_ response: SingleUseCardCreateResponse) {
    singleUseCardToken = response.consumerCardToken
    DispatchQueue.main.async { self.currentScreen = .checkout }
  }

  private func handleConfirmCardSucces(_ response: SingleUseCardConfirmResponse) {
    virtualCard = response.paymentDetails.virtualCard
    DispatchQueue.main.async { self.currentScreen = .singleUseCard }
  }

  private func handleCancelCardSuccess() {
    DispatchQueue.main.async { self.commandHandler(.dismissOnCardCancellation) }
  }

  // MARK: - API Calls

  func callSingleUseCardCreateAPI() {
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
  private func callSingleUseCardCancelAPI() {
    guard
      let singleUseCardToken = singleUseCardToken,
      let checkoutToken = checkoutToken
    else {
      os_log("checkoutToken and cardToken are required", log: .singleUseCard, type: .debug)
      return
    }

    let payload = SingleUseCardCancelRequest(
      consumerCardToken: singleUseCardToken,
      token: checkoutToken,
      aggregator: aggregatorName
    )

    APIPlusNetworkService.shared.request(
      endpoint: .singleUseCardCancel(payload),
      mode: mode
    ) { [weak self] result in
      result.fold(
        successTransform: { _ in self?.handleCancelCardSuccess() },
        errorTransform: { _ in return }
      )
    }
  }
}
