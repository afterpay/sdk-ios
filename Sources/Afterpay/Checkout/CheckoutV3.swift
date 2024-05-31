//
//  CheckoutV3.swift
//  Afterpay
//
//  Created by Chris Kolbu on 12/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

// swiftlint:disable nesting
enum CheckoutV3 {

  struct Request: Encodable {
    let shopDirectoryId: String
    let shopDirectoryMerchantId: String

    let amount: Money
    let shippingAmount: Money?
    let taxAmount: Money?

    let items: [Item]
    let consumer: Consumer
    let merchant: Merchant
    let shipping: Contact?
    let billing: Contact?

    let isCashAppPay: Bool

    init(
      consumer: CheckoutV3Consumer,
      orderTotal: OrderTotal,
      items: [CheckoutV3Item] = [],
      isCashAppPay: Bool = false,
      configuration: CheckoutV3Configuration
    ) {
      self.shopDirectoryId = configuration.shopDirectoryId
      self.shopDirectoryMerchantId = configuration.shopDirectoryMerchantId

      self.amount = Money(
        amount: configuration.region.formatted(currency: orderTotal.total),
        currency: configuration.region.currencyCode
      )

      self.shippingAmount = Money(
        amount: configuration.region.formatted(currency: orderTotal.shipping),
        currency: configuration.region.currencyCode
      )

      self.taxAmount = Money(
        amount: configuration.region.formatted(currency: orderTotal.tax),
        currency: configuration.region.currencyCode
      )

      self.items = items.map { Item($0, configuration.region) }

      self.consumer = Consumer(consumer)

      self.merchant = Merchant(
        redirectConfirmUrl: URL(string: "https://www.afterpay.com")!,
        redirectCancelUrl: URL(string: "https://www.afterpay.com")!
      )

      self.shipping = Contact(consumer.shippingInformation)
      self.billing = Contact(consumer.billingInformation)

      self.isCashAppPay = isCashAppPay
    }

    // MARK: - Inner types

    struct Item: Encodable {
      let name: String
      let quantity: UInt
      let price: Money
      let sku: String?
      let pageUrl: URL?
      let imageUrl: URL?
      let categories: [[String]]?
      let estimatedShipmentDate: String?

      init(_ item: CheckoutV3Item, _ region: CheckoutV3Configuration.Region) {
        self.name = item.name
        self.quantity = item.quantity
        self.price = Money(
          amount: region.formatted(currency: item.price),
          currency: region.currencyCode
        )
        self.sku = item.sku
        self.pageUrl = item.pageUrl
        self.imageUrl = item.imageUrl
        self.categories = item.categories
        self.estimatedShipmentDate = item.estimatedShipmentDate
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

    struct Contact: Encodable {
      let name: String
      let line1: String
      let line2: String?
      let area1: String?
      let area2: String?
      let region: String?
      let postcode: String?
      let countryCode: String
      let phoneNumber: String?

      init?(_ contact: CheckoutV3Contact?) {
        guard let contact = contact else {
          return nil
        }
        self.name = contact.name
        self.line1 = contact.line1
        self.line2 = contact.line2
        self.area1 = contact.area1
        self.area2 = contact.area2
        self.region = contact.region
        self.postcode = contact.postcode
        self.countryCode = contact.countryCode
        self.phoneNumber = contact.phoneNumber
      }
    }
  }

  struct Response: Decodable {
    let token: String
    let confirmMustBeCalledBefore: Date?
    let redirectCheckoutUrl: URL
    let singleUseCardToken: String
  }

  struct ResultData: CheckoutV3Data {
    let cardDetails: VirtualCard
    let cardValidUntil: Date?
    let tokens: CheckoutV3Tokens
  }

  struct ResultTokens: CheckoutV3Tokens {
    let token: String
    let singleUseCardToken: String
    let ppaConfirmToken: String
  }

  struct MerchantReferenceUpdate: Encodable {
    let token: String
    let singleUseCardToken: String
    let ppaConfirmToken: String
    let merchantReference: String
  }

}
