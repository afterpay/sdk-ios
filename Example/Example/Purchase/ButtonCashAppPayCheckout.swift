//
//  ButtonCashAppPayCheckout.swift
//  Example
//
//  Created by Mark Mroz on 2024-06-17.
//  Copyright © 2024 Afterpay. All rights reserved.
//

import PayKit
import Afterpay

enum ButtonCashAppPayError: Error {
  case checkoutReason(CashAppSigningResult.CashAppSigningCancellationReason)
  case checkout(error: Error)

  case customerRequestDeclined
  case customerRequestMissingGrant
  case customerRequest(error: Error)

  case confirmation(error: Error)
}

protocol ButtonCashAppPayCheckoutDelegate: AnyObject {
  func didFinish(result: Result<ConfirmationV3.CashAppPayResponse, ButtonCashAppPayError>)
}

final class ButtonCashAppPayCheckout {

  // MARK: - Properties

  weak var delegate: ButtonCashAppPayCheckoutDelegate?

  // MARK: - Private Properties

  private lazy var paykit: CashAppPay? = {
    guard let clientId = Afterpay.cashAppClientId else {
      assertionFailure("Couldn't get cash app client id")
      return nil
    }
    let sdk = CashAppPay(
      clientID: clientId,
      endpoint: Afterpay.environment == .production ? .production : .sandbox
    )
    sdk.addObserver(self)
    return sdk
  }()

  private var checkoutPayload: CheckoutV3CashAppPayPayload! {
    didSet {
      createCustomerRequest(
        brandID: checkoutPayload.cashAppSigningData.brandId,
        amount: checkoutPayload.cashAppSigningData.amount
      )
    }
  }

  private var grant: CustomerRequest.Grant! {
    didSet {
      confirmCheckout(grant: grant)
    }
  }

  // MARK: - Private

  func checkoutV3(consumer: Consumer, cartTotal: Decimal) {
    Afterpay.checkoutV3WithCashAppPay(
      consumer: consumer,
      orderTotal: OrderTotal(total: cartTotal, shipping: .zero, tax: .zero)
    ) { [weak self] result in
      switch result {
      case .success(let data):
        self?.checkoutPayload = data
      case .cancelled(let reason):
        self?.delegate?.didFinish(result: .failure(.checkoutReason(reason)))
      case .failure(let error):
        self?.delegate?.didFinish(result: .failure(.checkout(error: error)))
      }
    }
  }

  private func createCustomerRequest(brandID: String, amount: UInt) {
    paykit?.createCustomerRequest(
      params: CreateCustomerRequestParams(
        actions: [
          .oneTimePayment(
            scopeID: brandID,
            money: Money(
              amount: amount,
              currency: .USD
            )
          ),
        ],
        redirectURL: URL(string: "aftersnack://callback")!,
        referenceID: nil,
        metadata: nil
      )
    )
  }

  private func authorizeCustomerRequest(customerRequest: CustomerRequest) {
    paykit?.authorizeCustomerRequest(customerRequest)
  }

  private func confirmCheckout(grant: CustomerRequest.Grant) {
    Afterpay.checkoutV3ConfirmForCashAppPay(
      token: checkoutPayload.token,
      singleUseCardToken: checkoutPayload.singleUseCardToken,
      cashAppPayCustomerID: grant.customerID,
      cashAppPayGrantID: grant.id,
      jwt: checkoutPayload.cashAppSigningData.jwt) { [weak self] result in
        switch result {
        case .success(let response):
          self?.delegate?.didFinish(result: .success(response))
        case .failure(let error):
          self?.delegate?.didFinish(result: .failure(.confirmation(error: error)))
        }
      }
  }
}

// MARK: - CashAppPayObserver

extension ButtonCashAppPayCheckout: CashAppPayObserver {
  func stateDidChange(to state: CashAppPayState) {
    switch state {
    case .notStarted,
    .creatingCustomerRequest,
    .updatingCustomerRequest,
    .redirecting,
    .polling,
    .refreshing:
      break
    case .readyToAuthorize(let customerRequest):
      authorizeCustomerRequest(customerRequest: customerRequest)
    case .declined:
      delegate?.didFinish(result: .failure(.customerRequestDeclined))
    case .approved(_, let grants):
      if let grant = grants.first {
        self.grant = grant
      } else {
        delegate?.didFinish(result: .failure(.customerRequestMissingGrant))
      }
    case .apiError(let apiError):
      delegate?.didFinish(result: .failure(.customerRequest(error: apiError)))
    case .integrationError(let integrationError):
      delegate?.didFinish(result: .failure(.customerRequest(error: integrationError)))
    case .networkError(let networkError):
      delegate?.didFinish(result: .failure(.customerRequest(error: networkError)))
    case .unexpectedError(let unexpectedError):
      delegate?.didFinish(result: .failure(.customerRequest(error: unexpectedError)))
    }
  }
}
