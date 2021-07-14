//
//  CheckoutV3Card.swift
//  Afterpay
//
//  Created by Chris Kolbu on 15/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public enum VirtualCard: Decodable {
  case card(Card)
  case tokenized(TokenizedCard)

  public init(from decoder: Decoder) throws {
    if let card = try? Card(from: decoder) {
      self = .card(card)
      return
    }
    do {
      let tokenizedCard = try TokenizedCard(from: decoder)
      self = .tokenized(tokenizedCard)
    } catch {
      guard error is DecodingError else {
        throw error
      }
      throw Error(message:
        "Could not parse expected `\(VirtualCard.self)` as `\(Card.self)` or `\(TokenizedCard.self)`"
      )
    }
  }

  public struct Error: LocalizedError {
    let message: String

    public var failureReason: String? {
      NSLocalizedString(message, comment: "Failure reason")
    }

    public var recoverySuggestion: String? {
      NSLocalizedString(
        "Please contact Afterpay",
        comment: "Recovery suggestion for a `VirtualCard` parsing error"
      )
    }
  }
}

public struct Card: Decodable {
  public let cardType: String
  public let cardNumber: String
  public let cvc: String
  public let expiryMonth: Int
  public let expiryYear: Int

  private enum CodingKeys: String, CodingKey {
    case cardNumber, cvc, expiry, cardType
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let expiryString = try container.decode(String.self, forKey: .expiry).split(separator: "-")

    guard expiryString.count == 2 else {
      throw DecodingError.dataCorruptedError(
        forKey: .expiry,
        in: container,
        debugDescription: "Expiry string wrong format Expected `-` as separator"
      )
    }

    guard
      let yearString = expiryString.first,
      let year = Int(yearString),
      let monthString = expiryString.last,
      let month = Int(monthString)
    else {
      throw DecodingError.dataCorruptedError(
        forKey: .expiry,
        in: container,
        debugDescription: "Expiry string wrong format Expected two integral values representing year and month"
      )
    }

    self.expiryYear = year
    self.expiryMonth = month
    self.cardNumber = try container.decode(String.self, forKey: .cardNumber)
    self.cvc = try container.decode(String.self, forKey: .cvc)
    self.cardType = try container.decode(String.self, forKey: .cardType)
  }
}

public struct TokenizedCard: Decodable {
  public let cardType: String
  public let cardToken: String
  public let cvc: String
  public let expiryMonth: Int
  public let expiryYear: Int

  private enum CodingKeys: String, CodingKey {
    case cardType, cardToken, cvc, expiry
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let expiryString = try container.decode(String.self, forKey: .expiry).split(separator: "-")

    guard expiryString.count == 2 else {
      throw DecodingError.dataCorruptedError(
        forKey: .expiry,
        in: container,
        debugDescription: "Expiry string wrong format Expected `-` as separator"
      )
    }

    guard
      let yearString = expiryString.first,
      let year = Int(yearString),
      let monthString = expiryString.last,
      let month = Int(monthString)
    else {
      throw DecodingError.dataCorruptedError(
        forKey: .expiry,
        in: container,
        debugDescription: "Expiry string wrong format Expected two integral values representing year and month"
      )
    }

    self.expiryYear = year
    self.expiryMonth = month
    self.cardToken = try container.decode(String.self, forKey: .cardToken)
    self.cvc = try container.decode(String.self, forKey: .cvc)
    self.cardType = try container.decode(String.self, forKey: .cardType)
  }
}
