//
//  ConfirmationV3.swift
//  Afterpay
//
//  Created by Chris Kolbu on 12/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

enum CancellationV3 {

  struct Request: Encodable {
    let token: String
    let ppaConfirmToken: String
    let singleUseCardToken: String
  }

}
