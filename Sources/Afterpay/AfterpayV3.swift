//
//  Afterpay.swift
//  Afterpay
//
//  Created by Chris Kolbu on 13/7/21.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Update merchant reference

/// Updates Afterpay's merchant reference for the transaction represented by the provided `tokens`.
/// - Parameters:
///   - merchantReference: A unique ID identifying the transaction.
///   - tokens: The set of tokens returned after a successful call to `Afterpay.presentCheckoutV3Modally`.
///   - configuration: A collection of options and values required to interact with the Afterpay API.
///   - requestHandler: A function that takes a `URLRequest` and a closure to handle the result.
///   - completion: The result of the user's completion (a success or cancellation). Returns on the main thread.
public func updateMerchantReferenceV3(
  with merchantReference: String,
  tokens: CheckoutV3Tokens,
  configuration: CheckoutV3Configuration? = getV3Configuration(),
  requestHandler: @escaping URLRequestHandler = URLSession.shared.dataTask,
  completion: @escaping (_ result: Result<Void, Error>) -> Void
) {
  guard let configuration = configuration else {
    return assertionFailure(
      "For updateMerchantReferenceV3 to function you must provide a `configuration` object via either "
        + "`Afterpay.updateMerchantReferenceV3` or `Afterpay.setV3Configuration`"
    )
  }
  do {
    var request = ApiV3.request(from: configuration.v3CheckoutUrl)
    request.httpMethod = "PUT"
    request.httpBody = try JSONEncoder().encode(
      CheckoutV3.MerchantReferenceUpdate(
        token: tokens.token,
        singleUseCardToken: tokens.singleUseCardToken,
        ppaConfirmToken: tokens.ppaConfirmToken,
        merchantReference: merchantReference
      )
    )
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")

    let task = ApiV3.request(requestHandler, request, completion: completion)
    task.resume()
  } catch {
    completion(.failure(error))
  }
}

// MARK: - Fetch merchant configuration

/// Returns the merchant configuration object, representing the merchant's applicable payment limits.
/// - Parameters:
///   - configuration: A collection of options and values required to interact with the Afterpay API.
///   - requestHandler: A function that takes a `URLRequest` and a closure to handle the result.
///   - completion: The result of the user's completion (a success or cancellation). Returns on the main thread.
public func fetchMerchantConfiguration(
  configuration: CheckoutV3Configuration? = getV3Configuration(),
  requestHandler: @escaping URLRequestHandler = URLSession.shared.dataTask,
  completion: @escaping (_ result: Result<Configuration, Error>) -> Void
) {
  guard let configuration = configuration else {
    return assertionFailure(
      "For fetchMerchantConfiguration to function you must provide a `configuration` object via either "
        + "`Afterpay.fetchMerchantConfiguration` or `Afterpay.setV3Configuration`"
    )
  }
  let request = ApiV3.request(from: configuration.v3ConfigurationUrl)
  let task = ApiV3.request(requestHandler, request, type: Configuration.Object.self) { result in
    switch result {
    case .success(let object):
      do {
        let config = try Configuration(object, configuration: configuration)
        completion(.success(config))
      } catch {
        completion(.failure(error))
      }
    case .failure(let error):
      completion(.failure(error))
    }
  }
  task.resume()
}

// MARK: - Checkout

/// Present Afterpay Checkout modally over the specified view controller. This method
/// - Parameters:
///   - viewController: The viewController on which `UIViewController.present` will be called.
///   The Afterpay Checkout View Controller will be presented modally over this view controller
///   or it's closest parent that is able to handle the presentation.
///   - consumer: The personal details of the customer, including shipping and billing addresses.
///   - orderTotal: The order total: `Decimal`s representing the subtotal, tax and shipping.
///   - items: An optional array of items that will be added to the checkout.
///   These are not used to calculate the total amount due.
///   - animated: Pass `true` to animate the presentation; otherwise, pass false.
///   - configuration: A collection of options and values required to interact with the Afterpay API.
///   - requestHandler: A function that takes a `URLRequest` and a closure to handle the result,
///   and returns a `URLSessionDataTask`. Defaults to `URLSession.shared.dataTask`.
///   - completion: The result of the user's completion (a success or cancellation). Returns on the main thread.
public func presentCheckoutV3Modally(
  over viewController: UIViewController,
  consumer: CheckoutV3Consumer,
  orderTotal: OrderTotal,
  items: [CheckoutV3Item] = [],
  buyNow: Bool,
  animated: Bool = true,
  configuration: CheckoutV3Configuration? = getV3Configuration(),
  requestHandler: @escaping URLRequestHandler = URLSession.shared.dataTask,
  completion: @escaping (_ result: CheckoutV3Result) -> Void
) {
  guard let configuration = configuration else {
    return assertionFailure(
      "For presentCheckoutV3Modally to function you must provide a `configuration` object via either "
        + "`Afterpay.presentCheckoutV3Modally` or `Afterpay.setV3Configuration`"
    )
  }

  var viewControllerToPresent: UIViewController = CheckoutV3ViewController(
    checkout: CheckoutV3.Request(
      consumer: consumer,
      orderTotal: orderTotal,
      items: items,
      configuration: configuration
    ),
    buyNow: buyNow,
    configuration: configuration,
    requestHandler: requestHandler,
    completion: completion
  )

  viewControllerToPresent = UINavigationController(rootViewController: viewControllerToPresent)
  viewController.present(viewControllerToPresent, animated: animated, completion: nil)
}

private var checkoutV3Configuration: CheckoutV3Configuration?

public func setV3Configuration(_ configuration: CheckoutV3Configuration) {
  checkoutV3Configuration = configuration
}

public func getV3Configuration() -> CheckoutV3Configuration? {
  checkoutV3Configuration
}

/// A collection of options and values required to interact with the Afterpay API.
public struct CheckoutV3Configuration {
  let shopDirectoryMerchantId: String
  let region: Region
  let environment: Environment

  /// Creates a collection of options and values required to interact with the Afterpay API.
  /// - Parameters:
  ///   - shopDirectoryMerchantId: A unique merchant identifier.
  ///   - region: The region serviced by the merchant.
  ///   - environment: The environment. Use `sandbox` for development purposes.
  public init(
    shopDirectoryMerchantId: String,
    region: Region,
    environment: Environment
  ) {
    self.shopDirectoryMerchantId = shopDirectoryMerchantId
    self.region = region
    self.environment = environment
  }

  // MARK: - Computed properties

  var shopDirectoryId: String {
    switch (region, environment) {
    case (_, .sandbox):
      return "cd6b7914412b407d80aaf81d855d1105"
    case (_, .production):
      return "e1e5632bebe64cee8e5daff8588e8f2f05ca4ed6ac524c76824c04e09033badc"
    }
  }

  var v3BaseUrl: URL {
    switch (region, environment) {
    case (.US, .sandbox):
      return URL(string: "https://api-plus.us-sandbox.afterpay.com/v3/button")!
    case (.US, .production):
      return URL(string: "https://api-plus.us.afterpay.com/v3/button")!
    // Currently the same URL as the US region
    case (.CA, .sandbox):
      return URL(string: "https://api-plus.us-sandbox.afterpay.com/v3/button")!
    case (.CA, .production):
      return URL(string: "https://api-plus.us.afterpay.com/v3/button")!
    }
  }

  var v3CheckoutUrl: URL {
    self.v3BaseUrl
  }

  var v3CheckoutConfirmationUrl: URL {
    v3BaseUrl.appendingPathComponent("confirm")
  }

  var v3ConfigurationUrl: URL {
    var components = URLComponents(
      url: v3BaseUrl.appendingPathComponent("merchant/config"),
      resolvingAgainstBaseURL: false
    )
    components?.queryItems = [
      URLQueryItem(name: "shopDirectoryId", value: shopDirectoryId),
      URLQueryItem(name: "shopDirectoryMerchantId", value: shopDirectoryMerchantId),
    ]
    guard let url = components?.url else {
      fatalError("Could not create valid URL for `\(Self.self).v3ConfigurationUrl`")
    }
    return url
  }

  // MARK: - Inner type

  /// Regions supporting V3 checkouts
  public enum Region {
    case US
    case CA

    var locale: Locale {
      switch self {
      case .US: return Locales.unitedStates
      case .CA: return Locales.canada
      }
    }

    var currencyCode: String {
      guard let currencyCode = self.locale.currencyCode else {
        switch self {
        case .US: return "USD"
        case .CA: return "CAD"
        }
      }
      return currencyCode
    }

    private static var formatter: NumberFormatter = {
      var formatter = NumberFormatter()
      formatter.numberStyle = .decimal
      // ISO 4217 specifies 2 decimal points
      formatter.maximumFractionDigits = 2
      formatter.roundingMode = .halfEven // Banker's rounding
      formatter.groupingSeparator = ""
      return formatter
    }()

    func formatted(currency: Decimal) -> String {
      return Self.formatter.string(from: currency as NSDecimalNumber)!
    }
  }
}
