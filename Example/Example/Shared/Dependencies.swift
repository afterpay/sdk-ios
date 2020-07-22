//
//  Dependencies.swift
//  Example
//
//  Created by Adam Campbell on 22/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import TrustKit

func initializeDependencies() {
  let configuration: [String: Any] = [
    kTSKSwizzleNetworkDelegates: false,
    kTSKPinnedDomains: [
      "portal.afterpay.com": [
        kTSKExpirationDate: "2022-06-25",
        kTSKPublicKeyHashes: ["nQ1Tu17lpJ/Hsr3545eCkig+X9ZPcxRQoe5WMSyyqJI="],
      ],
      "portal.sandbox.afterpay.com": [
        kTSKExpirationDate: "2021-07-05",
        kTSKPublicKeyHashes: ["15mVY9KpcF6J/UzKCS2AfUjUWPVsIvxi9PW0XuFnvH4="],
      ],
    ],
  ]

  TrustKit.initSharedInstance(withConfiguration: configuration)
}
