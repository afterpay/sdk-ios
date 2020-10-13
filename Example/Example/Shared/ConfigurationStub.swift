//
//  ConfigurationStub.swift
//  Example
//
//  Created by Adam Campbell on 12/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Foundation

var configurationStub = ConfigurationStub()

struct ConfigurationStub {

  var minimumAmount: String? = "5.00" {
    didSet { updateConfiguration() }
  }

  var maximumAmount: String = "1000.00" {
    didSet { updateConfiguration() }
  }

  var currencyCode: String = "USD" {
    didSet { updateConfiguration() }
  }

  var locale: Locale = Locale(identifier: "en_US") {
    didSet { updateConfiguration() }
  }

  var responseData: Data? {
    let response = ConfigurationResponse(
      minimumAmount: minimumAmount.map { .init(amount: $0, currency: currencyCode) },
      maximumAmount: .init(amount: maximumAmount, currency: currencyCode)
    )

    return try? JSONEncoder().encode(response)
  }

  private var configuration: Configuration? {
    try? Configuration(
      minimumAmount: minimumAmount,
      maximumAmount: maximumAmount,
      currencyCode: currencyCode,
      locale: locale
    )
  }

  private func updateConfiguration() {
    if Settings.config == .stub {
      Afterpay.setConfiguration(configuration)
    }
  }

}
