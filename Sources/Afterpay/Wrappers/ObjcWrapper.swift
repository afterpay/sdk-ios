//
//  ObjcWrapper.swift
//  Afterpay
//
//  Created by Adam Campbell on 25/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

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

  // swiftlint:enable function_parameter_count

}
