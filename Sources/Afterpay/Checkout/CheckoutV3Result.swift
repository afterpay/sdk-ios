//
//  ConfirmationV3.swift
//  Afterpay
//
//  Created by Chris Kolbu on 14/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

/// Data returned from a successful V3 checkout
public protocol CheckoutV3Data {
  /// The virtual card details
  var cardDetails: CardDetails { get }
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
