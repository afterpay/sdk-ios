//
//  ConfirmationV3+CashAppPay.swift .swift
//  Afterpay
//
//  Created by Mark Mroz on 2024-05-31.
//  Copyright © 2024 Afterpay. All rights reserved.
//

import Foundation

extension ConfirmationV3 {
  struct CashAppPayRequest: Encodable {
    let token: String
    let singleUseCardToken: String
    let cashAppPspInfo: CashAppPspInfo
  }

  public struct CashAppPayResponse: Decodable {
    public let paymentDetails: ConfirmationV3.Response.PaymentDetails
    public let cardValidUntil: Date?
  }
}

extension ConfirmationV3.CashAppPayRequest {
  struct CashAppPspInfo: Encodable {
    let externalCustomerId: String
    let externalGrantId: String
    let jwt: String
  }
}
