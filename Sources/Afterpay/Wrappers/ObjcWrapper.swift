//
//  ObjcWrapper.swift
//  Afterpay
//
//  Created by Adam Campbell on 25/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

// swiftlint:disable file_length
// swiftlint:disable type_body_length
@objc(APAfterpay)
public final class ObjcWrapper: NSObject {

  @available(*, unavailable)
  public override init() {}

  /// Should not be instantiated, instances should be of type CheckoutResultSuccess or CheckoutResultCancelled
  @objc(APCheckoutResult)
  public class CheckoutResult: NSObject {
    internal override init() {}

    static func success(token: String) -> CheckoutResultSuccess {
      CheckoutResultSuccess(token: token)
    }

    static func cancelled(reason: CancellationReason) -> CheckoutResultCancelled {
      CheckoutResultCancelled(reason: reason)
    }
  }

  @objc(APCheckoutResultSuccess)
  public class CheckoutResultSuccess: CheckoutResult {
    @objc public let token: String

    init(token: String) {
      self.token = token
    }
  }

  @objc(APCheckoutResultCancelled)
  public class CheckoutResultCancelled: CheckoutResult {
    @objc public let reason: CancellationReason

    init(reason: CancellationReason) {
      self.reason = reason
    }
  }

  @objc(APCancellationReason)
  public class CancellationReason: NSObject {
    /// Should not be instantiated, instances should be of type CancellationReasonUserInitiated,
    /// CancellationReasonNetworkError or CancellationReasonInvalidURL
    internal override init() {}

    static func userInitiated() -> CancellationReasonUserInitiated {
      CancellationReasonUserInitiated(())
    }

    static func unretrievableUrl() -> CancellationReasonUnretrievableUrl {
      CancellationReasonUnretrievableUrl(())
    }

    static func networkError(error: Error) -> CancellationReasonNetworkError {
      CancellationReasonNetworkError(error)
    }

    static func invalidURL(_ url: URL) -> CancellationReasonInvalidURL {
      CancellationReasonInvalidURL(url)
    }

  }

  @objc(APCancellationReasonUserInitiated)
  public class CancellationReasonUserInitiated: CancellationReason {
    init(_ void: ()) {}
  }

  @objc(APCancellationReasonUnretrievableUrl)
  public class CancellationReasonUnretrievableUrl: CancellationReason {
    init(_ void: ()) {}
  }

  @objc(APCancellationReasonNetworkError)
  public class CancellationReasonNetworkError: CancellationReason {
    @objc public let error: Error

    init(_ error: Error) {
      self.error = error
    }
  }

  @objc(APCancellationReasonInvalidURL)
  public class CancellationReasonInvalidURL: CancellationReason {
    @objc public let url: URL

    init(_ url: URL) {
      self.url = url
    }
  }

  @objc(presentCheckoutModallyOverViewController:loadingCheckoutURL:animated:completion:)
  public static func presentCheckoutModally(
    over viewController: UIViewController,
    loading checkoutURL: URL,
    animated: Bool,
    completion: @escaping (CheckoutResult) -> Void
  ) {
    Afterpay.presentCheckoutModally(
      over: viewController,
      loading: checkoutURL,
      animated: animated,
      completion: { result in
        switch result {
        case .success(let token):
          completion(.success(token: token))

        case .cancelled(.userInitiated):
          completion(.cancelled(reason: .userInitiated()))

        case .cancelled(.unretrievableUrl):
          completion(.cancelled(reason: .unretrievableUrl()))

        case .cancelled(.networkError(let error)):
          completion(.cancelled(reason: .networkError(error: error)))

        case .cancelled(reason: .invalidURL(let url)):
          completion(.cancelled(reason: .invalidURL(url)))
        }
      }
    )
  }

  @objc
  public static func setAuthenticationChallengeHandler(
    _ handler: @escaping AuthenticationChallengeHandler
  ) {
    Afterpay.setAuthenticationChallengeHandler(handler)
  }

  // swiftlint:disable function_parameter_count

  @objc
  public static func setConfiguration(
    minimumAmount: String,
    maximumAmount: String,
    currencyCode: String,
    locale: Locale,
    environment: String,
    consumerLocale: Locale,
    error: UnsafeMutablePointer<NSError>
  ) {
    let environment = Environment(rawValue: environment) ?? .production
    let result = Result {
      try Configuration(
        minimumAmount: minimumAmount,
        maximumAmount: maximumAmount,
        currencyCode: currencyCode,
        locale: locale,
        environment: environment,
        consumerLocale: consumerLocale)
    }

    switch result {
    case .success(let configuration):
      Afterpay.setConfiguration(configuration)
    case .failure(let configurationError):
      error.initialize(to: configurationError as NSError)
    }
  }

  // Cash App
  // swiftlint:disable type_name

  @objc public static var cashAppClientId: String? {
    Afterpay.cashAppClientId
  }

  // Cash App signing

  @objc(APCashAppSigningResult)
  public class CashAppSigningResult: NSObject {
    internal override init() {}

    static func success(data: CashAppSigningData) -> CashAppSigningResultSuccess {
      CashAppSigningResultSuccess(signingData: data)
    }

    static func failed(reason: CashAppSigningFailedReason) -> CashAppSigningResultFailed {
      CashAppSigningResultFailed(reason: reason)
    }
  }

  @objc(APCashAppSigningData)
  public class CashAppSigningData: NSObject {
    @objc public let jwt: String
    @objc public let amount: UInt
    @objc public let redirectUri: URL
    @objc public let merchantId: String
    @objc public let brandId: String

    init(
      jwt: String,
      amount: UInt,
      redirectUri: URL,
      merchantId: String,
      brandId: String
    ) {
      self.jwt = jwt
      self.amount = amount
      self.redirectUri = redirectUri
      self.merchantId = merchantId
      self.brandId = brandId
    }
  }

  @objc(APCashAppSigningResultSuccess)
  public class CashAppSigningResultSuccess: CashAppSigningResult {
    @objc public let signingData: CashAppSigningData

    init(signingData: CashAppSigningData) {
      self.signingData = signingData
    }
  }

  @objc(APCashAppSigningResultFailed)
  public class CashAppSigningResultFailed: CashAppSigningResult {
    @objc public let reason: CashAppSigningFailedReason

    init(reason: CashAppSigningFailedReason) {
      self.reason = reason
    }
  }

  @objc(APCashAppSigningFailedReason)
  public class CashAppSigningFailedReason: NSObject {
    /// Should not be instantiated, instances should be of type CancellationReasonUserInitiated,
    /// CancellationReasonNetworkError or CancellationReasonInvalidURL
    internal override init() {}

    static func invalidAmount() -> CashAppSigningFailedReasonInvalidAmount {
      CashAppSigningFailedReasonInvalidAmount(())
    }

    static func invalidRedirectUrl() -> CashAppSigningFailedReasonInvalidRedirectUrl {
      CashAppSigningFailedReasonInvalidRedirectUrl(())
    }

    static func jwtDecodeNullError() -> CashAppSigningFailedReasonJwtDecodeNullError {
      CashAppSigningFailedReasonJwtDecodeNullError(())
    }

    static func responseDecodeError() -> CashAppSigningFailedReasonResponseDecodeError {
      CashAppSigningFailedReasonResponseDecodeError(())
    }

    static func jwtDecodeError(error: Error) -> CashAppSigningFailedReasonJwtDecodeError {
      CashAppSigningFailedReasonJwtDecodeError(error)
    }

    static func httpError(errorCode: Int) -> CashAppSigningFailedReasonHttpError {
      CashAppSigningFailedReasonHttpError(errorCode)
    }

    static func error(error: Error) -> CashAppSigningFailedReasonError {
      CashAppSigningFailedReasonError(error)
    }
  }

  @objc(APCashAppSigningFailedReasonInvalidAmount)
  public class CashAppSigningFailedReasonInvalidAmount: CashAppSigningFailedReason {
    init(_ void: ()) {}
  }

  @objc(APCashAppSigningFailedReasonInvalidRedirectUrl)
  public class CashAppSigningFailedReasonInvalidRedirectUrl: CashAppSigningFailedReason {
    init(_ void: ()) {}
  }

  @objc(APCashAppSigningFailedReasonJwtDecodeNullError)
  public class CashAppSigningFailedReasonJwtDecodeNullError: CashAppSigningFailedReason {
    init(_ void: ()) {}
  }

  @objc(APCashAppSigningFailedReasonResponseDecodeError)
  public class CashAppSigningFailedReasonResponseDecodeError: CashAppSigningFailedReason {
    init(_ void: ()) {}
  }

  @objc(APCashAppSigningFailedReasonJwtDecodeError)
  public class CashAppSigningFailedReasonJwtDecodeError: CashAppSigningFailedReason {
    @objc public let error: Error

    init(_ error: Error) {
      self.error = error
    }
  }

  @objc(APCashAppSigningFailedReasonHttpError)
  public class CashAppSigningFailedReasonHttpError: CashAppSigningFailedReason {
    @objc public let errorCode: Int

    init(_ errorCode: Int) {
      self.errorCode = errorCode
    }
  }

  @objc(APCashAppSigningFailedReasonError)
  public class CashAppSigningFailedReasonError: CashAppSigningFailedReason {
    @objc public let error: Error

    init(_ error: Error) {
      self.error = error
    }
  }

  @objc
  public static func signCashAppOrderToken(
    token: String,
    completion: @escaping (CashAppSigningResult) -> Void
  ) {
    Afterpay.signCashAppOrderToken(
      token,
      completion: { result in
        switch result {
        case .success(let signingData):
          let APSigningData = CashAppSigningData(
            jwt: signingData.jwt,
            amount: signingData.amount,
            redirectUri: signingData.redirectUri,
            merchantId: signingData.merchantId,
            brandId: signingData.brandId
          )

          return completion(.success(data: APSigningData))
        case .failed(reason: .invalidAmount):
          completion(.failed(reason: .invalidAmount()))

        case .failed(reason: .invalidRedirectUrl):
          completion(.failed(reason: .invalidRedirectUrl()))

        case .failed(reason: .jwtDecodeNullError):
          completion(.failed(reason: .jwtDecodeNullError()))

        case .failed(reason: .responseDecodeError):
          completion(.failed(reason: .responseDecodeError()))

        case .failed(reason: .jwtDecodeError(error: let error)):
          completion(.failed(reason: .jwtDecodeError(error: error)))

        case .failed(reason: .httpError(errorCode: let errorCode)):
          completion(.failed(reason: .httpError(errorCode: errorCode)))

        case .failed(reason: .error(error: let error)):
          completion(.failed(reason: .error(error: error)))
        }
      }
    )
  }

  // Cash App signing end

  // Cash App validate order

  @objc(APCashAppValidationResultSuccess)
  public class CashAppValidationResultSuccess: CashAppValidationResult {
    @objc public let validationData: CashAppValidationData

    init(validationData: CashAppValidationData) {
      self.validationData = validationData
    }
  }

  @objc(APCashAppValidationData)
  public class CashAppValidationData: NSObject {
    @objc public let cashAppTag: String
    @objc public let status: String
    @objc public let callbackBaseUrl: String

    init(
      cashAppTag: String,
      status: String,
      callbackBaseUrl: String
    ) {
      self.cashAppTag = cashAppTag
      self.status = status
      self.callbackBaseUrl = callbackBaseUrl
    }
  }

  @objc(APCashAppValidationResult)
  public class CashAppValidationResult: NSObject {
    internal override init() {}

    static func success(data: CashAppValidationData) -> CashAppValidationResultSuccess {
      CashAppValidationResultSuccess(validationData: data)
    }

    static func failed(reason: CashAppValidationFailedReason) -> CashAppValidationResultFailed {
      CashAppValidationResultFailed(reason: reason)
    }
  }

  @objc(APCashAppValidationResultFailed)
  public class CashAppValidationResultFailed: CashAppValidationResult {
    @objc public let reason: CashAppValidationFailedReason

    init(reason: CashAppValidationFailedReason) {
      self.reason = reason
    }
  }

  @objc(APCashAppValidationFailedReason)
  public class CashAppValidationFailedReason: NSObject {
    /// Should not be instantiated, instances should be of type CancellationReasonUserInitiated,
    /// CancellationReasonNetworkError or CancellationReasonInvalidURL
    internal override init() {}

    static func nilData() -> CashAppValidationFailedReasonNilData {
      CashAppValidationFailedReasonNilData(())
    }

    static func responseDecodeError() -> CashAppValidationFailedReasonResponseDecodeError {
      CashAppValidationFailedReasonResponseDecodeError(())
    }

    static func unknownError() -> CashAppValidationFailedReasonUnknownError {
      CashAppValidationFailedReasonUnknownError(())
    }

    static func invalid() -> CashAppValidationFailedReasonInvalid {
      CashAppValidationFailedReasonInvalid(())
    }

    static func httpError(errorCode: Int, message: String) -> CashAppValidationFailedReasonHttpError {
      CashAppValidationFailedReasonHttpError(errorCode, message)
    }

    static func error(error: Error) -> CashAppValidationFailedReasonError {
      CashAppValidationFailedReasonError(error)
    }
  }

  @objc(APCashAppValidationFailedReasonNilData)
  public class CashAppValidationFailedReasonNilData: CashAppValidationFailedReason {
    init(_ void: ()) {}
  }

  @objc(APCashAppValidationFailedReasonResponseDecodeError)
  public class CashAppValidationFailedReasonResponseDecodeError: CashAppValidationFailedReason {
    init(_ void: ()) {}
  }

  @objc(APCashAppValidationFailedReasonUnknownError)
  public class CashAppValidationFailedReasonUnknownError: CashAppValidationFailedReason {
    init(_ void: ()) {}
  }

  @objc(APCashAppValidationFailedReasonInvalid)
  public class CashAppValidationFailedReasonInvalid: CashAppValidationFailedReason {
    init(_ void: ()) {}
  }

  @objc(APCashAppValidationFailedReasonHttpError)
  public class CashAppValidationFailedReasonHttpError: CashAppValidationFailedReason {
    @objc public let errorCode: Int
    @objc public let message: String

    init(_ errorCode: Int, _ message: String) {
      self.errorCode = errorCode
      self.message = message
    }
  }

  @objc(APCashAppValidationFailedReasonError)
  public class CashAppValidationFailedReasonError: CashAppValidationFailedReason {
    @objc public let error: Error

    init(_ error: Error) {
      self.error = error
    }
  }

  @objc
  public static func validateCashAppOrder(
    jwt: String,
    customerId: String,
    grantId: String,
    completion: @escaping (CashAppValidationResult) -> Void
  ) {
    Afterpay.validateCashAppOrder(
      jwt: jwt,
      customerId: customerId,
      grantId: grantId,
      completion: { result in
        switch result {

        case .success(data: let data):
          let APvalidationData = CashAppValidationData(
            cashAppTag: data.cashAppTag,
            status: data.status,
            callbackBaseUrl: data.callbackBaseUrl
          )

          completion(.success(data: APvalidationData))

        case .failed(reason: .nilData):
          completion(.failed(reason: .nilData()))

        case .failed(reason: .responseDecodeError):
          completion(.failed(reason: .responseDecodeError()))

        case .failed(reason: .unknownError):
          completion(.failed(reason: .unknownError()))

        case .failed(reason: .invalid):
          completion(.failed(reason: .invalid()))

        case .failed(reason: .httpError(errorCode: let errorCode, message: let message)):
          completion(.failed(reason: .httpError(errorCode: errorCode, message: message)))

        case .failed(reason: .error(error: let error)):
          completion(.failed(reason: .error(error: error)))
        }
      }
    )
  }

  // Cash App validate order end

  // swiftlint:enable type_name
  // Cash App end

  // swiftlint:enable function_parameter_count
  // swiftlint:enable type_body_length
}

// swiftlint:enable file_length
