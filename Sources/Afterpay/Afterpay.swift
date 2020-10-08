//
//  Afterpay.swift
//  Afterpay
//
//  Created by Adam Campbell on 17/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Checkout

/// Present Afterpay Checkout modally over the specified view controller loading your
/// generated checkout URL.
/// - Parameters:
///   - viewController: The viewController on which `UIViewController.present` will be called.
///   The Afterpay Checkout View Controller will be presented modally over this view controller
///   or it's closest parent that is able to handle the presentation.
///   - checkoutURL: The checkout URL to load generated via the /checkouts endpoint on the
///   Afterpay backend.
///   - animated: Pass true to animate the presentation; otherwise, pass false.
///   - completion: The block executed after the user has completed the checkout.
///   - result: The result of the user's completion (a success or cancellation).
public func presentCheckoutModally(
  over viewController: UIViewController,
  loading checkoutURL: URL,
  animated: Bool = true,
  completion: @escaping (_ result: CheckoutResult) -> Void
) {
  var viewControllerToPresent: UIViewController = CheckoutWebViewController(
    checkoutUrl: checkoutURL,
    completion: completion
  )

  if #available(iOS 13.0, *) {
  } else {
    // Wrap the modal in a navigation controller to allow dismiss via a bar button item prior
    // to popover modals in iOS13
    viewControllerToPresent = UINavigationController(rootViewController: viewControllerToPresent)
  }

  viewController.present(viewControllerToPresent, animated: animated, completion: nil)
}

// MARK: - Authentication

/// A handler that is passed a `challenge` a `completionHandler`. If the challenge has been
/// handled (by calling the completionHandler) `true` should be returned, `false` otherwise.
/// - Parameters:
///   - challenge: The authentication challenge.
///   - completionHandler: A block to invoke to respond to the challenge. The disposition parameter
///   must be one of the constants of the enumerated type URLSession.AuthChallengeDisposition. When
///   disposition is URLSession.AuthChallengeDisposition.useCredential, the credential parameter
///   specifies the credential to use, or nil to continue without a credential.
public typealias AuthenticationChallengeHandler = (
  _ challenge: URLAuthenticationChallenge,
  _ completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void
) -> Bool

var authenticationChallengeHandler: AuthenticationChallengeHandler = { _, _ in false }

/// Set the authentication challenge handler used by the Afterpay SDK to respond to authentication
/// challenges during the checkout process.
/// - Parameter handler: A handler that should return whether or not the challenge has been handled.
/// `true` if the passed completionHandler has been called, `false` otherwise.
public func setAuthenticationChallengeHandler(_ handler: @escaping AuthenticationChallengeHandler) {
  authenticationChallengeHandler = handler
}

// MARK: - Configuration

let notificationCenter = NotificationCenter()

extension NSNotification.Name {
  static let configurationUpdated = NSNotification.Name("ConfigurationUpdated")
}

private var configuration: Configuration?

func getConfiguration() -> Configuration? {
  configuration
}

/// Sets the Configuration object to use for rendering UI Components in the Afterpay SDK.
/// - Parameter configuration: The configuration or nil to clear.
public func setConfiguration(_ configuration: Configuration?) {
  Afterpay.configuration = configuration

  notificationCenter.post(name: .configurationUpdated, object: configuration)
}
