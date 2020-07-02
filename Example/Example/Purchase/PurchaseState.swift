//
//  PurchaseState.swift
//  Example
//
//  Created by Adam Campbell on 1/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

enum PurchaseState {
  case browsing(products: [ProductDisplay])
  case viewing(cart: CartDisplay)
  case paying(url: URL)
}
