//
//  Consumer.swift
//  Afterpay
//
//  Created by Chris Kolbu on 14/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

/// A minimal implementation of `CheckoutV3Consumer`
public struct Consumer: CheckoutV3Consumer {

  public var email: String
  public var givenNames: String?
  public var surname: String?
  public var phoneNumber: String?
  public var shippingInformation: CheckoutV3Contact?
  public var billingInformation: CheckoutV3Contact?

  public init(
    email: String,
    givenNames: String? = nil,
    surname: String? = nil,
    phoneNumber: String? = nil,
    shippingInformation: CheckoutV3Contact? = nil,
    billingInformation: CheckoutV3Contact? = nil
  ) {
    self.email = email
    self.givenNames = givenNames
    self.surname = surname
    self.phoneNumber = phoneNumber
    self.shippingInformation = shippingInformation
    self.billingInformation = billingInformation
  }

}
