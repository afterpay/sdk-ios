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

/// Which Cash App Pay grant type to request when CAP runs through the Afterpay button.
///
/// Both modes hit the same Afterpay endpoints (`POST /v3/button`,
/// `POST /v2/payments/sign-payment`, `POST /v3/button/confirm`); the only
/// difference is the PayKit action attached to the customer request.
enum CashAppPayMode {
  /// PayKit `.oneTimePayment(scopeID:, money:)` — single-use authorization.
  case oneTime
  /// PayKit `.onFilePayment(scopeID:, accountReferenceID:)` — grant suitable
  /// for storing on-file and re-charging via merchant-initiated transactions.
  case onFile
}

protocol ButtonCashAppPayCheckoutDelegate: AnyObject {
  func didFinish(result: Result<ConfirmationV3.CashAppPayResponse, ButtonCashAppPayError>)
}

final class ButtonCashAppPayCheckout {

  // MARK: - Properties

  weak var delegate: ButtonCashAppPayCheckoutDelegate?

  // MARK: - Private Properties

  private var mode: CashAppPayMode = .oneTime

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

  func checkoutV3(consumer: Consumer, cartTotal: Decimal, mode: CashAppPayMode) {
    self.mode = mode
    NSLog("[CAP-AP] mode=\(mode) starting checkoutV3WithCashAppPay total=\(cartTotal)")
    Afterpay.checkoutV3WithCashAppPay(
      consumer: consumer,
      orderTotal: OrderTotal(total: cartTotal, shipping: .zero, tax: .zero)
    ) { [weak self] result in
      switch result {
      case .success(let data):
        NSLog(
          "[CAP-AP] checkoutV3 OK token=\(data.token) " +
          "singleUseCardToken=\(data.singleUseCardToken) " +
          "brandId=\(data.cashAppSigningData.brandId) " +
          "amount=\(data.cashAppSigningData.amount) " +
          "merchantId=\(data.cashAppSigningData.merchantId) " +
          "jwt=\(data.cashAppSigningData.jwt)"
        )
        self?.checkoutPayload = data
      case .cancelled(let reason):
        NSLog("[CAP-AP] checkoutV3 CANCELLED reason=\(reason)")
        self?.delegate?.didFinish(result: .failure(.checkoutReason(reason)))
      case .failure(let error):
        NSLog("[CAP-AP] checkoutV3 FAILED error=\(error)")
        self?.delegate?.didFinish(result: .failure(.checkout(error: error)))
      }
    }
  }

  private func createCustomerRequest(brandID: String, amount: UInt) {
    // Both modes target the same Afterpay endpoints; only the PayKit action
    // type changes. `.onFilePayment` carries no Money — the order amount is
    // enforced server-side via the signed JWT supplied to `/v3/button/confirm`.
    let action: PaymentAction
    switch mode {
    case .oneTime:
      action = .oneTimePayment(
        scopeID: brandID,
        money: Money(amount: amount, currency: .USD)
      )
    case .onFile:
      action = .onFilePayment(
        scopeID: brandID,
        accountReferenceID: nil
      )
    }
    NSLog("[CAP-AP] createCustomerRequest mode=\(mode) brandId=\(brandID) action=\(action)")
    paykit?.createCustomerRequest(
      params: CreateCustomerRequestParams(
        actions: [action],
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
    NSLog(
      "[CAP-AP] confirmCheckout token=\(checkoutPayload.token) " +
      "customerId=\(grant.customerID) grantId=\(grant.id)"
    )
    Afterpay.checkoutV3ConfirmForCashAppPay(
      token: checkoutPayload.token,
      singleUseCardToken: checkoutPayload.singleUseCardToken,
      cashAppPayCustomerID: grant.customerID,
      cashAppPayGrantID: grant.id,
      jwt: checkoutPayload.cashAppSigningData.jwt) { [weak self] result in
        switch result {
        case .success(let response):
          NSLog("[CAP-AP] confirm OK paymentDetails=\(response.paymentDetails)")
          self?.delegate?.didFinish(result: .success(response))
        case .failure(let error):
          NSLog("[CAP-AP] confirm FAILED error=\(error)")
          self?.delegate?.didFinish(result: .failure(.confirmation(error: error)))
        }
      }
  }
}

// MARK: - CashAppPayObserver

extension ButtonCashAppPayCheckout: CashAppPayObserver {
  func stateDidChange(to state: CashAppPayState) {
    NSLog("[CAP-AP] PayKit state=\(state)")
    switch state {
    case .notStarted,
    .creatingCustomerRequest,
    .updatingCustomerRequest,
    .redirecting,
    .polling,
    .refreshing:
      break
    case .readyToAuthorize(let customerRequest):
      NSLog("[CAP-AP] readyToAuthorize requestId=\(customerRequest.id)")
      authorizeCustomerRequest(customerRequest: customerRequest)
    case .declined:
      NSLog("[CAP-AP] customer request DECLINED")
      delegate?.didFinish(result: .failure(.customerRequestDeclined))
    case .approved(let request, let grants):
      NSLog(
        "[CAP-AP] customer request APPROVED requestId=\(request.id) " +
        "grants=\(grants.map { "id=\($0.id) customerId=\($0.customerID) action=\($0.action)" })"
      )
      if let grant = grants.first {
        self.grant = grant
      } else {
        delegate?.didFinish(result: .failure(.customerRequestMissingGrant))
      }
    case .apiError(let apiError):
      NSLog("[CAP-AP] PayKit apiError=\(apiError)")
      delegate?.didFinish(result: .failure(.customerRequest(error: apiError)))
    case .integrationError(let integrationError):
      NSLog("[CAP-AP] PayKit integrationError=\(integrationError)")
      delegate?.didFinish(result: .failure(.customerRequest(error: integrationError)))
    case .networkError(let networkError):
      NSLog("[CAP-AP] PayKit networkError=\(networkError)")
      delegate?.didFinish(result: .failure(.customerRequest(error: networkError)))
    case .unexpectedError(let unexpectedError):
      NSLog("[CAP-AP] PayKit unexpectedError=\(unexpectedError)")
      delegate?.didFinish(result: .failure(.customerRequest(error: unexpectedError)))
    }
  }
}
