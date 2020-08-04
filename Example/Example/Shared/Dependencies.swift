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
        kTSKExpirationDate: "2021-07-05",
        kTSKPublicKeyHashes: ["15mVY9KpcF6J/UzKCS2AfUjUWPVsIvxi9PW0XuFnvH4=", backupHash],
      ],
    ],
  ]

  TrustKit.initSharedInstance(withConfiguration: configuration)

  // Pin Afterpay's payment portal certificates using TrustKit
  Afterpay.setAuthenticationChallengeHandler { challenge, completionHandler -> Bool in
    let validator = TrustKit.sharedInstance().pinningValidator
    return validator.handle(challenge, completionHandler: completionHandler)
  }

  // Configure the Afterpay SDK with the merchant configuration
  getCachedConfiguration { result in
    let configurationResult: Result<Configuration, Error> = result.flatMap { response in
      do {
        let configuration = try Configuration(
          minimumAmount: response.minimumAmount?.amount,
          maximumAmount: response.maximumAmount.amount,
          currencyCode: response.maximumAmount.currency)
        return .success(configuration)
      } catch {
        return .failure(error)
      }
    }

    switch configurationResult {
    case .success(let configuration):
      Afterpay.setConfiguration(configuration)
    case .failure(let error):
      // Logs network, decoding and Afterpay configuration errors raised
      let errorDescription = error.localizedDescription
      os_log(.error, "Failed to set configuration with error: %{public}@", errorDescription)
    }
  }
}
