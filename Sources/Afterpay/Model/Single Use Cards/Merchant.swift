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

  public init(name: String) {
    redirectConfirmUrl = URL(string: "afterpay://consumer_cards/confirm")!
    redirectCancelUrl = URL(string: "afterpay://consumer_cards/cancel")!
    self.name = name
  }
}
