//
//  Contact.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 10/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public struct Contact: Codable {
  var name: String
  var line1: String
  var area1: String?
  var region: String?
  var postcode: String?
  var countryCode: String
  var phoneNumber: String?

  public init(
    name: String,
    line1: String,
    area1: String? = nil,
    region: String? = nil,
    postcode: String? = nil,
    countryCode: String,
    phoneNumber: String? = nil
  ) {
    self.name = name
    self.line1 = line1
    self.area1 = area1
    self.region = region
    self.postcode = postcode
    self.countryCode = countryCode
    self.phoneNumber = phoneNumber
  }
}
