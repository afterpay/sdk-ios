//
//  ShippingAddress.swift
//  Afterpay
//
//  Created by Adam Campbell on 7/12/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

public struct ShippingAddress: Decodable {
  var countryCode: String?
  var postcode: String?
  var phoneNumber: String?
  var state: String?
  var suburb: String?
}
