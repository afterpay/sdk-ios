//
//  Merchant.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 10/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public struct Merchant: Encodable {
  let redirectConfirmUrl: URL
  let redirectCancelUrl: URL
  let name: String

  public init(redirectConfirmUrl: URL, redirectCancelUrl: URL, name: String) {
    self.redirectConfirmUrl = redirectConfirmUrl
    self.redirectCancelUrl = redirectCancelUrl
    self.name = name
  }
}
