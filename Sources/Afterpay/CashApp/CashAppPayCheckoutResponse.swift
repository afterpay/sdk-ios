//
//  CashAppPayCheckoutResponse.swift
//  Afterpay
//
//  Created by Scott Antonac on 7/12/2022.
//  Copyright © 2022 Afterpay. All rights reserved.
//

import Foundation

struct CashAppPayCheckoutResponse: Decodable {
  var externalBrandId: String
  var jwtToken: String
  var redirectUrl: String

  internal func decodeJwtToken() -> CashAppPayCheckoutJWT? {
    do {
      let json = try JSONSerialization.data(withJSONObject: JWT.decode(jwtToken: jwtToken))
      let decoder = JSONDecoder()
      let jwtData = try decoder.decode(CashAppPayCheckoutJWT.self, from: json)

      return jwtData
    } catch {
      return nil
    }
  }
}

struct CashAppCheckoutAmount: Decodable {
  var amount: String
  var currency: String
  var symbol: String
}

struct CashAppPayCheckoutJWT: Decodable {
  var amount: CashAppCheckoutAmount
  var token: String
  var externalMerchantId: String
  var redirectUrl: String
}
