//
//  ConfirmationV3.swift
//  Afterpay
//
//  Created by Chris Kolbu on 14/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public protocol CheckoutV3Data {
  var cancellation: CancellationClosure { get }
  var merchantReferenceUpdate: MerchantReferenceUpdateClosure { get }
  var cardValidUntil: Date? { get }
  var cardDetails: CardDetails { get }
}
