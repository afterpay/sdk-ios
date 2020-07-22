//
//  Dependencies.swift
//  Example
//
//  Created by Adam Campbell on 22/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import TrustKit

struct Dependencies {

  var pinningValidator: TSKPinningValidator { TrustKit.sharedInstance().pinningValidator }

  init() {
    let afterpay: [String: Any] = [
      kTSKExpirationDate: "2022-06-25",
      kTSKPublicKeyHashes: ["nQ1Tu17lpJ/Hsr3545eCkig+X9ZPcxRQoe5WMSyyqJI="],
    ]

    let sandbox: [String: Any] = [
      kTSKExpirationDate: "2021-07-05",
      kTSKPublicKeyHashes: ["15mVY9KpcF6J/UzKCS2AfUjUWPVsIvxi9PW0XuFnvH4="],
    ]

    let configuration: [String: Any] = [
      kTSKSwizzleNetworkDelegates: false,
      kTSKPinnedDomains: [
        "portal.afterpay.com": afterpay,
        "portal.sandbox.afterpay.com": sandbox,
      ],
    ]

    TrustKit.initSharedInstance(withConfiguration: configuration)
  }

}
