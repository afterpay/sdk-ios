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

public typealias DidCommenceCheckoutClosure = (
  _ completion: @escaping CheckoutURLResultCompletion
) -> Void

public typealias ShippingAddressDidChangeClosure = (
  _ address: Address,
  _ completion: @escaping ShippingOptionsCompletion
) -> Void

public typealias ShippingOptionsDidChangeClosure = (_ shippingOption: ShippingOption) -> Void

/// Present Afterpay Checkout modally over the specified view controller loading your
/// generated checkout URL.
/// - Parameters:
///   - viewController: The viewController on which `UIViewController.present` will be called.
///   The Afterpay Checkout View Controller will be presented modally over this view controller
///   or it's closest parent that is able to handle the presentation.
///   - checkoutURL: The checkout URL to load generated via the /checkouts endpoint on the
///   Afterpay backend. If not provided it will be loaded via calling `didCommenceCheckout` on the
///   configured `ExpressCheckoutHandler` object.
///   - animated: Pass true to animate the presentation; otherwise, pass false.
///   - completion: The block executed after the user has completed the checkout.
///   - result: The result of the user's completion (a success or cancellation).
public func presentCheckoutModally(
  over viewController: UIViewController,
  didCommenceCheckout: DidCommenceCheckoutClosure? = nil,
  shippingAddressDidChange: ShippingAddressDidChangeClosure? = nil,
  shippingOptionDidChange: ShippingOptionsDidChangeClosure? = nil,
  animated: Bool = true,
  completion: @escaping (_ result: CheckoutResult) -> Void
) {
  var viewControllerToPresent: UIViewController = InteractiveCheckoutViewController(
    didCommenceCheckout: didCommenceCheckout,
    shippingAddressDidChange: shippingAddressDidChange,
    shippingOptionDidChange: shippingOptionDidChange,
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

// MARK: - Express Checkout

public typealias CheckoutURLResultCompletion = (_ result: Result<URL, Error>) -> Void
public typealias ShippingOptionsCompletion = (_ shippingOptions: [ShippingOption]) -> Void

/// A handler of web view events typically assiciated with express checkout. Conforming to this
/// protocol and calling `setExpressCheckoutHandler` will enable completion of express checkouts.
public protocol ExpressCheckoutHandler: AnyObject {

  /// Called after checkout is launched via `presentCheckoutModally` when there is no `checkoutURL`
  /// present. In this way creating a token / URL can be deferred until it is needed. This method
  /// also works with non express checkouts.
  /// - Parameters:
  ///   - completion: A completion for which the `result` of an attempt to generate a token or form
  ///   a URL should be passed to. Passing a success will load the checkout URL and a failure will present a dialogue
  ///   to the user for which they will either decide to retry or close the modal.
  func didCommenceCheckout(completion: @escaping CheckoutURLResultCompletion)

  /// Called when an express checkout is launched inside the checkout web view. Provided the address
  /// shipping options should be formed and passed to `completion` for the user to choose from.
  /// - Parameters:
  ///   - address: The address for which the item will be shipped to.
  ///   - completion: The closure that the formed shipping options should be passed to. The shipping
  ///   options passed should match the provided `address`.
  func shippingAddressDidChange(address: Address, completion: @escaping ShippingOptionsCompletion)

  /// Called after the user selects one of the shipping options provided by the `completion` of
  /// `shippingAddressDidChange`.
  /// - Parameter shippingOption: The selected shipping option.
  func shippingOptionDidChange(shippingOption: ShippingOption)
}

private weak var expressCheckoutHandler: ExpressCheckoutHandler?

func getExpressCheckoutHandler() -> ExpressCheckoutHandler? {
  expressCheckoutHandler
}

/// Set the express checkout handler for handling asychronous web view events mostly associated with
/// express checkout. The handler is retained weakly and as such a strong reference should be
/// maintained outside of the SDK.
/// - Parameter handler: The Express Checkout Handler.
public func setExpressCheckoutHandler(_ handler: ExpressCheckoutHandler?) {
  expressCheckoutHandler = handler
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

  /// Fires when the Afterpay configuration is updated with the previous configuration
  static let configurationUpdated = NSNotification.Name("ConfigurationUpdated")

}

private var configuration: Configuration?

func getConfiguration() -> Configuration? {
  configuration
}

/// Sets the Configuration object to use for rendering UI Components in the Afterpay SDK.
/// - Parameter configuration: The configuration or nil to clear.
public func setConfiguration(_ configuration: Configuration?) {
  let previousConfiguration = Afterpay.configuration

  Afterpay.configuration = configuration

  notificationCenter.post(name: .configurationUpdated, object: previousConfiguration)
}

func getLocale() -> Locale {
  getConfiguration()?.locale ?? Locales.unitedStates
}
