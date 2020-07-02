//
//  PurchaseState.swift
//  Example
//
//  Created by Adam Campbell on 1/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

enum PurchaseState {
  case products([ProductDisplay])
  case cart(CartState)
}

enum CartState {
  case displaying(CartDisplay)
  case presenting(checkoutURL: URL)
}
