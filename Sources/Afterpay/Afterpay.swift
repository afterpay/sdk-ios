//
//  Afterpay.swift
//  Afterpay
//
//  Created by Adam Campbell on 17/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public enum Afterpay {

  /// Present the Afterpay Checkout Web Flow modally over the specified view controller loading your
  /// generated checkout URL.
  /// - Parameters:
  ///   - viewController: The viewController on which `UIViewController.present` will be called.
  ///   The Afterpay Checkout View Controller will be presented modally over this view controller
  ///   or it's closest parent that is able to handle the presentation.
  ///   - checkoutUrl: The checkout URL to load generated via the /checkouts endpoint on the
  ///   Afterpay backend.
  ///   - animated: Pass true to animate the presentation; otherwise, pass false.
  ///   - presentationCompletion: The block to execute after the presentation finishes. This block
  ///   has no return value and takes no parameters. You may specify nil for this parameter.
  ///   - cancelHandler: The block executed when the user cancels the Afterpay Web Flow.
  ///   - successHandler: The block executed when the user successfully completes the Afterpay Web
  ///   Flow.
  ///   - token: The token associated with the Afterpay payment.
  public static func presentCheckout(
    over viewController: UIViewController,
    loading checkoutUrl: URL,
    animated: Bool = true,
    presentationCompletion: (() -> Void)? = nil,
    cancelHandler: (() -> Void)? = nil,
    successHandler: @escaping (_ token: String) -> Void
  ) {
    let webViewController = WebViewController(
      checkoutUrl: checkoutUrl,
      cancelHandler: cancelHandler ?? {},
      successHandler: successHandler
    )

    let navigationController = UINavigationController(rootViewController: webViewController)

    if #available(iOS 13.0, *) {
      navigationController.isModalInPresentation = true
    }

    viewController.present(
      navigationController,
      animated: animated,
      completion: presentationCompletion
    )
  }

}
