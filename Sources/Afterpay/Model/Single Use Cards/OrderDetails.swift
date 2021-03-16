//
//  OrderDetails.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 12/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

struct OrderDetails: Decodable {
  let consumer: Consumer
  let billing: Contact?
  let shipping: Contact?
  let courier: Courier?
  let items: [Item]?
  let discounts: [Discount]?
}
