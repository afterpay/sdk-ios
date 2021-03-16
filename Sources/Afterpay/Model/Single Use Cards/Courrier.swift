//
//  Courrier.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 12/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

struct Courier: Decodable {
  let shippedAt: String?
  let name: String?
  let tracking: String?
  let priority: String?

  public init(shippedAt: String?, name: String?, tracking: String?, priority: String?) {
    self.shippedAt = shippedAt
    self.name = name
    self.tracking = tracking
    self.priority = priority
  }
}
