//
//  CheckoutV3.swift
//  Afterpay
//
//  Created by Chris Kolbu on 12/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

// swiftlint:disable nesting
@frozen enum CheckoutV3 {
  struct Request: Encodable {
    let shopDirectoryId: String
    let shopDirectoryMerchantId: String
    let merchantPublicKey: String

    let amount: Amount
    let items: [Item]
    let consumer: Consumer
    let merchant: Merchant

    init(
      consumer: CheckoutV3Consumer,
      amount: Decimal,
      items: [CheckoutV3Item] = [],
      configuration: CheckoutV3Configuration
    ) {
      self.shopDirectoryId = configuration.shopDirectoryId
      self.shopDirectoryMerchantId = configuration.shopDirectoryMerchantId
      self.merchantPublicKey = configuration.merchantPublicKey

      self.amount = Amount(
        amount: configuration.region.formatted(currency: amount),
        currency: configuration.region.currencyCode
      )
      self.items = items.map { Item($0, configuration.region) }

      self.consumer = Consumer(consumer)

      self.merchant = Merchant(
        redirectConfirmUrl: URL(string: "https://www.afterpay.com")!,
        redirectCancelUrl: URL(string: "https://www.afterpay.com")!
      )
    }

    // MARK: - Inner types

    struct Amount: Encodable {
      let amount: String
      let currency: String
    }

    struct Item: Encodable {
      let name: String
      let quantity: Int
      let price: Amount
      let sku: String?
      let pageUrl: URL?
      let imageUrl: URL?
      let categories: [[String]]?

      init(_ item: CheckoutV3Item, _ region: CheckoutV3Configuration.Region) {
        self.name = item.name
        self.quantity = item.quantity
        self.price = Amount(
          amount: region.formatted(currency: item.price),
          currency: region.currencyCode
        )
        self.sku = item.sku
        self.pageUrl = item.pageUrl
        self.imageUrl = item.imageUrl
        self.categories = item.categories
      }
    }

    struct Merchant: Encodable {
      let redirectConfirmUrl: URL
      let redirectCancelUrl: URL
    }

    struct Consumer: Encodable {
      let email: String
      let givenNames: String?
      let surname: String?
      let phoneNumber: String?

      init(_ consumer: CheckoutV3Consumer) {
        self.email = consumer.email
        self.givenNames = consumer.givenNames
        self.surname = consumer.surname
        self.phoneNumber = consumer.phoneNumber
      }
    }
  }

  enum Response: Decodable {
    case success(CheckoutResponse)
    case error(CheckoutError)

    init(from decoder: Decoder) throws {
      if let error = try? CheckoutError(from: decoder) {
        self = .error(error)
        return
      }
      self = .success(try CheckoutResponse(from: decoder))
    }
  }

  struct CheckoutResponse: Decodable {
    let token: String
    let confirmMustBeCalledBefore: Date?
    let redirectCheckoutUrl: URL
    let singleUseCardToken: String
  }

  struct CheckoutError: Decodable, LocalizedError {
    let errorCode: String
    let errorId: String
    let message: String
    let httpStatusCode: Int

    public var failureReason: String? {
      message
    }
  }
}
