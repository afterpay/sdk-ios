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

  /// Present the Afterpay Checkout Web Flow modally from the passed view controller loading your
  /// generated checkout URL.
  /// - Parameters:
  ///   - checkoutUrl: The checkout URL to load generated via the /checkouts endpoint on the
  ///   Afterpay backend.
  ///   - viewController: The viewController on which `UIViewController.present` will be called.
  ///   - animated: Pass true to animate the presentation; otherwise, pass false.
  ///   - completion: The block to execute after the presentation finishes. This block has no return
  ///   value and takes no parameters. You may specify nil for this parameter.
  public static func presentCheckout(
    loading checkoutUrl: URL,
    from viewController: UIViewController,
    animated: Bool = true,
    completion: (() -> Void)? = nil
  ) {
    let checkoutViewController = CheckoutViewController(checkoutUrl: checkoutUrl)
    viewController.present(checkoutViewController, animated: animated, completion: completion)
  }

}
