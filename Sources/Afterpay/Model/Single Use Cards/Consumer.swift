//
//  Consumer.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 10/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public struct Consumer: Codable {
  let phoneNumber: String?
  let givenNames: String?
  let surname: String?
  let email: String

  public init(phoneNumber: String?, givenNames: String?, surname: String?, email: String) {
    self.phoneNumber = phoneNumber
    self.givenNames = givenNames
    self.surname = surname
    self.email = email
  }
}
