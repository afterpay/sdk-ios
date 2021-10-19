//
//  ShippingAddress.swift
//  Afterpay
//
//  Created by Adam Campbell on 7/12/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

public struct ShippingAddress: Decodable {

  public var countryCode: String?
  public var postcode: String?
  public var phoneNumber: String?
  public var state: String?
  public var suburb: String?

}
