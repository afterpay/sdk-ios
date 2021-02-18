//
//  Item.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 10/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public struct Item: Codable {
  public let name: String
  public let sku: String?
  public let quantity: UInt
  public let pageUrl: URL
  public let imageUrl: URL?
  public let price: Money
  public let categories: [[String]]?

  public init(name: String, sku: String?, quantity: UInt, pageUrl: URL, imageUrl: URL?, price: Money, categories: [[String]]?) {
    self.name = name
    self.sku = sku
    self.quantity = quantity
    self.pageUrl = pageUrl
    self.imageUrl = imageUrl
    self.price = price
    self.categories = categories
  }
}
