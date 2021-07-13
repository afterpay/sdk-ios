//
//  Afterpay.swift
//  Afterpay
//
//  Created by Chris Kolbu on 13/7/21.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Checkout

/// Returns the merchant configuration object, representing the merchant's applicable payment limits.
/// - Parameters:
///   - configuration: A collection of options and values required to interact with the Afterpay API.
///   - requestHandler: A function that takes a `URLRequest` and a closure to handle the result.
///   - completion: The result of the user's completion (a success or cancellation).
public func fetchMerchantConfiguration(
  configuration: CheckoutV3Configuration? = getV3Configuration(),
  requestHandler: @escaping URLRequestHandler = URLSession.shared.dataTask,
  completion: @escaping (_ result: Result<Configuration, Error>) -> Void
) {
  guard let configuration = configuration else {
    return assertionFailure(
      "For fetchMerchantConfiguration to function you must set `configuration` via either "
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

/// Present Afterpay Checkout modally over the specified view controller. This method
/// - Parameters:
///   - viewController: The viewController on which `UIViewController.present` will be called.
///   The Afterpay Checkout View Controller will be presented modally over this view controller
///   or it's closest parent that is able to handle the presentation.
///   - consumer: The personal details of the customer.
///   - total: The order total, represented as an unrounded `Decimal`.
///   - items: An optional array of items that will be added to the checkout.
///   These are not used as the basis of the order `total`.
///   - animated: Pass `true` to animate the presentation; otherwise, pass false.
///   - configuration: A collection of options and values required to interact with the Afterpay API.
///   - requestHandler: A function that takes a `URLRequest` and a closure to handle the result.
///   and returns a `URLSessionDataTask`. Defaults to `URLSession.shared.dataTask`.
///   - completion: The result of the user's completion (a success or cancellation).
public func presentCheckoutV3Modally(
  over viewController: UIViewController,
  consumer: CheckoutV3Consumer,
  total: Decimal,
  items: [CheckoutV3Item] = [],
  animated: Bool = true,
  configuration: CheckoutV3Configuration? = getV3Configuration(),
  requestHandler: @escaping URLRequestHandler = URLSession.shared.dataTask,
  completion: @escaping (_ result: CheckoutResult) -> Void
) {
  guard let configuration = configuration else {
    return assertionFailure(
      "For checkout to function you must set `configuration` via either "
        + "`Afterpay.presentCheckoutV3Modally` or `Afterpay.setV3Configuration`"
    )
  }

  var viewControllerToPresent: UIViewController = CheckoutV3ViewController(
    checkout: CheckoutV3.Request(consumer: consumer, amount: total, configuration: configuration),
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
  let shopDirectoryId: String
  let shopDirectoryMerchantId: String
  let merchantPublicKey: String
  let region: Region
  let environment: Environment

  public init(
    shopDirectoryId: String,
    shopDirectoryMerchantId: String,
    merchantPublicKey: String,
    region: Region,
    environment: Environment
  ) {
    self.shopDirectoryId = shopDirectoryId
    self.shopDirectoryMerchantId = shopDirectoryMerchantId
    self.merchantPublicKey = merchantPublicKey
    self.region = region
    self.environment = environment
  }

  // MARK: - Computed properties

  var v3CheckoutUrl: URL {
    switch (region, environment) {
    case (.US, .sandbox):
      return URL(string: "https://api-plus.us-sandbox.afterpay.com/v3/button")!
    case (.US, .production):
      return URL(string: "https://api-plus.us.afterpay.com/v3/button")!
    }
  }

  var v3CheckoutConfirmationUrl: URL {
    switch (region, environment) {
    case (.US, .sandbox):
      return URL(string: "https://api-plus.us-sandbox.afterpay.com/v3/button/confirm")!
    case (.US, .production):
      return URL(string: "https://api-plus.us.afterpay.com/v3/button/confirm")!
    }
  }

  var v3ConfigurationUrl: URL {
    var url: URL
    switch (region, environment) {
    case (.US, .sandbox):
      url = URL(string: "https://api-plus.us-sandbox.afterpay.com/v3/button/merchant/config")!
    case (.US, .production):
      url = URL(string: "https://api-plus.us.afterpay.com/v3/button/merchant/config")!
    }
    var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
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

    var locale: Locale {
      switch self {
      case .US: return Locale(identifier: "en_US")
      }
    }

    var currencyCode: String {
      switch self {
      case .US: return "USD"
      }
    }

    private static let formatter = NumberFormatter()

    func formatted(currency: Decimal) -> String {
      Self.formatter.numberStyle = .decimal
      return Self.formatter.string(from: currency as NSDecimalNumber)!
    }
  }
}

public protocol CheckoutV3Consumer {
  var email: String { get }
  var givenNames: String? { get }
  var surname: String? { get }
  var phoneNumber: String? { get }
}

public protocol CheckoutV3Item {
  /// Product name. Limited to 255 characters.
  var name: String { get }
  /// The quantity of the item, stored as a signed 32-bit integer.
  var quantity: Int { get }
  /// The unit price of the individual item. Must be a positive value.
  var price: Decimal { get }
  /// Product SKU. Limited to 128 characters.
  var sku: String? { get }
  /// The canonical URL for the item's Product Detail Page. Limited to 2048 characters.
  var pageUrl: URL? { get }
  /// A URL for a web-optimised photo of the item, suitable for use directly as the src attribute of an img tag.
  /// Limited to 2048 characters.
  var imageUrl: URL? { get }
  /// An array of arrays to accommodate multiple categories that might apply to the item.
  /// Each array contains comma separated strings with the left-most category being the top level category.
  var categories: [[String]]? { get }
}
