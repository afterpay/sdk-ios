//
//  CardDetails.swift
//  Afterpay
//
//  Created by Chris Kolbu on 12/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public protocol CardDetails {
  var cardNumber: String { get }
  var cvc: String { get }
  var expiryMonth: Int { get}
  var expiryYear: Int { get }
}
