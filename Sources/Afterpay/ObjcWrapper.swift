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
@available(swift, obsoleted: 1.0, message: "This wrapper should only be used from Objective-C")
public final class AfterpayWrapper: NSObject {

  @available(*, unavailable)
  public override init() {}

  /// Cannot be instantiated, instances will be of type CheckoutResultSuccess or
  /// CheckoutResultCancelled
  @objc(APCheckoutResult)
  public class CheckoutResult: NSObject {
    @available(*, unavailable)
    override init() {}

    static func success(token: String) -> CheckoutResultSuccess {
      CheckoutResultSuccess(token: token)
    }

    static func cancelled(error: Error?) -> CheckoutResultCancelled {
      CheckoutResultCancelled(error: error)
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
    @objc public let error: Error?

    init(error: Error?) {
      self.error = error
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
        case .cancelled(let error):
          completion(.cancelled(error: error))
        }
      }
    )
  }

}
