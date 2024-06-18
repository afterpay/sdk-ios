//
//  CheckoutV3Protocols.swift
//  Afterpay
//
//  Created by Chris Kolbu on 14/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

/// Data returned from a successful V3 checkout
public protocol CheckoutV3Data {
  /// The virtual card details
  var cardDetails: VirtualCard { get }
  /// The time before which an authorization needs to be made on the virtual card.
  var cardValidUntil: Date? { get }
  /// The collection of tokens required to update the merchant reference or cancel the virtual card
  var tokens: CheckoutV3Tokens { get }
}

public protocol CheckoutV3Tokens {
  var token: String { get }
  var singleUseCardToken: String { get }
  var ppaConfirmToken: String { get }
}

@frozen public enum CheckoutV3Result {
  case success(data: CheckoutV3Data)
  case cancelled(reason: CheckoutResult.CancellationReason)
}

public protocol CheckoutV3Consumer {
  /// The consumer’s email address. Limited to 128 characters.
  var email: String { get }
  /// The consumer’s first name and any middle names. Limited to 128 characters.
  var givenNames: String? { get }
  /// The consumer’s last name. Limited to 128 characters.
  var surname: String? { get }
  /// The consumer’s phone number. Limited to 32 characters.
  var phoneNumber: String? { get }
  /// The consumer's shipping information.
  var shippingInformation: CheckoutV3Contact? { get }
  /// The consumer's billing information.
  var billingInformation: CheckoutV3Contact? { get }
}

public protocol CheckoutV3Contact {
  /// Full name of contact. Limited to 255 characters
  var name: String { get }
  /// First line of the address. Limited to 128 characters
  var line1: String { get }
  /// Second line of the address. Limited to 128 characters.
  var line2: String? { get }
  /// Australian suburb, U.S. city, New Zealand town or city, U.K. Postal town.
  /// Maximum length is 128 characters.
  var area1: String? { get }
  /// New Zealand suburb, U.K. village or local area. Maximum length is 128 characters.
  var area2: String? { get }
  /// U.S. state, Australian state, U.K. county, New Zealand region. Maximum length is 128 characters.
  var region: String? { get }
  /// The zip code or equivalent. Maximum length is 128 characters.
  var postcode: String? { get }
  /// The two-character ISO 3166-1 country code.
  var countryCode: String { get }
  /// The phone number, in E.123 format. Maximum length is 32 characters.
  var phoneNumber: String? { get }
}

public protocol CheckoutV3Item {
  /// Product name. Limited to 255 characters.
  var name: String { get }
  /// The quantity of the item, stored as a signed 32-bit integer.
  var quantity: UInt { get }
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
  /// The estimated date when the order will be shipped. YYYY-MM or YYYY-MM-DD format.
  var estimatedShipmentDate: String? { get }
}
