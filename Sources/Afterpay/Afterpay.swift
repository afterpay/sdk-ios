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

// MARK: - Checkout V2

/// Optional checkout flags to set when using `presentCheckoutV2Modally` that change the experience
/// for the end user within the checkout.
public struct CheckoutV2Options {

  /// Setting `pickup` to `true` when working with an express order will allow you to specify a
  /// pickup address when creating an order token via the `shipping` object. This also prevents the
  /// user from selecting a delivery address.
  public var pickup: Bool?

  /// Setting `buyNow` to `true` will display a 'Buy Now' button at the end of a user's checkout
  /// journey. This signals the intent to bypass review and immediately capture the payment.
  public var buyNow: Bool?

  /// Setting `shippingOptionRequired` to `false` when working with an express order will prevent
  /// the user from selecting shipping options within checkout.
  public var shippingOptionRequired: Bool?

  public init(pickup: Bool? = nil, buyNow: Bool? = nil, shippingOptionRequired: Bool? = nil) {
    self.pickup = pickup
    self.buyNow = buyNow
    self.shippingOptionRequired = shippingOptionRequired
  }
}

public typealias Token = String

public typealias CheckoutTokenResultCompletion = (_ result: Result<Token, Error>) -> Void

public typealias DidCommenceCheckoutClosure = (
  _ completion: @escaping CheckoutTokenResultCompletion
) -> Void

public typealias ShippingOptionsCompletion = (_ shippingOptions: [ShippingOption]) -> Void

public typealias ShippingAddressDidChangeClosure = (
  _ address: ShippingAddress,
  _ completion: @escaping ShippingOptionsCompletion
) -> Void

public typealias ShippingOptionsDidChangeClosure = (_ shippingOption: ShippingOption) -> Void

/// Present Afterpay Checkout modally over the specified view controller. This method calls the
/// passed closures to facilitate loading the checkoutURL on demand falling back to the
/// `CheckoutV2Handler` if set. Failing to handle `didCommenceCheckout` will result in an
/// assertion failure.
/// - Parameters:
///   - viewController: The viewController on which `UIViewController.present` will be called.
///   The Afterpay Checkout View Controller will be presented modally over this view controller
///   or it's closest parent that is able to handle the presentation.
///   - didCommenceCheckout: The closure called to request that the checkout URL be loaded via the
///   /checkouts endpoint on the Afterpay backend.
///   - shippingAddressDidChange: Called when an express checkout is launched or when the address is
///   changed. Provided the address shipping options should be formed and passed to `completion`
///   for the user to choose from.
///   - shippingOptionDidChange: Called after the user selects one of the shipping options provided
///   by the `completion` of `shippingAddressDidChange`.
///   - animated: Pass true to animate the presentation; otherwise, pass false.
///   - completion: The block executed after the user has completed the checkout.
///   - result: The result of the user's completion (a success or cancellation).
public func presentCheckoutV2Modally(
  over viewController: UIViewController,
  animated: Bool = true,
  options: CheckoutV2Options = .init(),
  didCommenceCheckout: DidCommenceCheckoutClosure? = nil,
  shippingAddressDidChange: ShippingAddressDidChangeClosure? = nil,
  shippingOptionDidChange: ShippingOptionsDidChangeClosure? = nil,
  completion: @escaping (_ result: CheckoutResult) -> Void
) {
  guard let configuration = getConfiguration() else {
    return assertionFailure(
      "Configuration must be provided before using `presentCheckoutV2Modally`"
    )
  }

  var viewControllerToPresent: UIViewController = CheckoutV2ViewController(
    configuration: configuration,
    options: options,
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

/// A handler of web view events typically associated with express checkout. Conforming to this
/// protocol and calling `setCheckoutV2Handler` will enable completion of express
/// checkouts without the passing of closures in the `presentCheckoutV2Modally` function.
public protocol CheckoutV2Handler: AnyObject {

  /// Called after checkout is launched via `presentCheckoutModally` when there is no `checkoutURL`
  /// present. In this way creating a token / URL can be deferred until it is needed. This method
  /// also works with standard (non express) checkouts.
  /// - Parameters:
  ///   - completion: A completion for which the `result` of an attempt to generate a token or form
  ///   a URL should be passed to. Passing a success will load the checkout URL and a failure will
  ///   present a dialogue to the user for which they will either decide to retry or close the
  ///   modal.
  func didCommenceCheckout(completion: @escaping CheckoutTokenResultCompletion)

  /// Called when an express checkout is launched inside the checkout web view. Provided the address
  /// shipping options should be formed and passed to `completion` for the user to choose from.
  /// - Parameters:
  ///   - address: The address for which the item will be shipped to.
  ///   - completion: The closure that the formed shipping options should be passed to. The shipping
  ///   options passed should match the provided `address`.
  func shippingAddressDidChange(address: ShippingAddress, completion: @escaping ShippingOptionsCompletion)

  /// Called after the user selects one of the shipping options provided by the `completion` of
  /// `shippingAddressDidChange`.
  /// - Parameter shippingOption: The selected shipping option.
  func shippingOptionDidChange(shippingOption: ShippingOption)
}

private weak var checkoutV2Handler: CheckoutV2Handler?

func getCheckoutV2Handler() -> CheckoutV2Handler? {
  checkoutV2Handler
}

/// Set the checkout handler for handling asychronous web view events mostly associated
/// with express checkout. The handler is retained weakly and as such a strong reference should be
/// maintained outside of the SDK.
/// - Parameter handler: The Checkout Handler.
public func setCheckoutV2Handler(_ handler: CheckoutV2Handler?) {
  checkoutV2Handler = handler
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
