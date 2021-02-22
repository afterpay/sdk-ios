//
//  Dependencies.swift
//  Example
//
//  Created by Adam Campbell on 22/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import CommonCrypto
import Foundation
import os.log
import TrustKit

func initializeDependencies() {
  // In a real world scenario this would be a real backup hash but for demonstration purposes
  // it is an empty hash to satisfy TrustKit's requirements
  let backupHash = Data(count: Int(CC_SHA256_DIGEST_LENGTH)).base64EncodedString()

  let configuration: [String: Any] = [
    kTSKSwizzleNetworkDelegates: false,
    kTSKPinnedDomains: [
      "portal.afterpay.com": [
        kTSKExpirationDate: "2022-06-25",
        kTSKPublicKeyHashes: ["nQ1Tu17lpJ/Hsr3545eCkig+X9ZPcxRQoe5WMSyyqJI=", backupHash],
      ],
      "portal.sandbox.afterpay.com": [
        kTSKExpirationDate: "2021-09-09",
        kTSKPublicKeyHashes: [
          "15mVY9KpcF6J/UzKCS2AfUjUWPVsIvxi9PW0XuFnvH4=",
          "TwuRz37J8epX4J1HDkoli34/3Woh7153cD3x9PFuh6I=",
          "FEzVOUp4dF3gI0ZVPRJhFbSJVXR+uQmMH65xhs1glH4=",
        ],
      ],
    ],
  ]

  TrustKit.initSharedInstance(withConfiguration: configuration)

  // Pin Afterpay's payment portal certificates using TrustKit
  // Uncomment this to enable pinning
  //
  // Afterpay.setAuthenticationChallengeHandler { challenge, completionHandler -> Bool in
  //   let validator = TrustKit.sharedInstance().pinningValidator
  //   return validator.handle(challenge, completionHandler: completionHandler)
  // }

  let repository = Repository.shared

  // Prime the app with the last cached configuration
  Afterpay.setConfiguration(repository.cachedConfiguration)

  // Configure the Afterpay SDK with the latest merchant configuration
  repository.fetchConfiguration { result in
    switch result {
    case .success(let configuration):
      Afterpay.setConfiguration(configuration)
    case .failure(let error):
      // Logs network, decoding and Afterpay configuration errors raised
      let errorDescription = error.localizedDescription
      os_log(.error, "Failed to fetch configuration with error: %{public}@", errorDescription)
    }
  }
}
