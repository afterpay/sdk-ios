//
//  LocaleTests.swift
//  AfterpayTests
//
//  Created by Scott Antonac on 29/6/2023.
//  Copyright © 2023 Afterpay. All rights reserved.
//

import Afterpay
import XCTest

private struct LocaleCombination {
  let merchantLocale: Locale
  let consumerLocale: Locale
  let valid: Bool
}

class LocaleTests: XCTestCase {
  let one = "1.00"
  let oneThousand = "1000.00"
  let usdCode = "USD"

  let enUsLocale = Locale(identifier: "en_US")
  let enAuLocale = Locale(identifier: "en_AU")
  let enCaLocale = Locale(identifier: "en_CA")
  let frCaLocale = Locale(identifier: "fr_CA")
  let frFrLocale = Locale(identifier: "fr_FR")
  let esEsLocale = Locale(identifier: "es_ES")

  let esUsLocale = Locale(identifier: "es_US")
  let jpJPLocale = Locale(identifier: "jp_JP")

  func testLocaleCombinationValid() {
    let localeCombinations: [LocaleCombination] = [
      LocaleCombination(merchantLocale: enUsLocale, consumerLocale: enUsLocale, valid: true),
      LocaleCombination(merchantLocale: enUsLocale, consumerLocale: enAuLocale, valid: true),
      LocaleCombination(merchantLocale: enUsLocale, consumerLocale: esUsLocale, valid: false),
      LocaleCombination(merchantLocale: enUsLocale, consumerLocale: frCaLocale, valid: false),
      LocaleCombination(merchantLocale: enUsLocale, consumerLocale: jpJPLocale, valid: false),

      LocaleCombination(merchantLocale: enAuLocale, consumerLocale: enAuLocale, valid: true),
      LocaleCombination(merchantLocale: enAuLocale, consumerLocale: enUsLocale, valid: true),
      LocaleCombination(merchantLocale: enAuLocale, consumerLocale: esUsLocale, valid: false),
      LocaleCombination(merchantLocale: enAuLocale, consumerLocale: frCaLocale, valid: false),
      LocaleCombination(merchantLocale: enAuLocale, consumerLocale: jpJPLocale, valid: false),

      LocaleCombination(merchantLocale: enCaLocale, consumerLocale: enCaLocale, valid: true),
      LocaleCombination(merchantLocale: enCaLocale, consumerLocale: enUsLocale, valid: true),
      LocaleCombination(merchantLocale: enCaLocale, consumerLocale: esUsLocale, valid: false),
      LocaleCombination(merchantLocale: enCaLocale, consumerLocale: frCaLocale, valid: true),
      LocaleCombination(merchantLocale: enCaLocale, consumerLocale: frFrLocale, valid: true),
      LocaleCombination(merchantLocale: enCaLocale, consumerLocale: jpJPLocale, valid: false),

      LocaleCombination(merchantLocale: frCaLocale, consumerLocale: enCaLocale, valid: true),
      LocaleCombination(merchantLocale: frCaLocale, consumerLocale: enUsLocale, valid: true),
      LocaleCombination(merchantLocale: frCaLocale, consumerLocale: esUsLocale, valid: false),
      LocaleCombination(merchantLocale: frCaLocale, consumerLocale: frCaLocale, valid: true),
      LocaleCombination(merchantLocale: frCaLocale, consumerLocale: frFrLocale, valid: true),
      LocaleCombination(merchantLocale: frCaLocale, consumerLocale: jpJPLocale, valid: false),

      LocaleCombination(merchantLocale: frFrLocale, consumerLocale: frFrLocale, valid: true),
      LocaleCombination(merchantLocale: frFrLocale, consumerLocale: enAuLocale, valid: true),
      LocaleCombination(merchantLocale: frFrLocale, consumerLocale: esUsLocale, valid: false),
      LocaleCombination(merchantLocale: frFrLocale, consumerLocale: esEsLocale, valid: false),
      LocaleCombination(merchantLocale: frFrLocale, consumerLocale: frCaLocale, valid: true),
      LocaleCombination(merchantLocale: frFrLocale, consumerLocale: enUsLocale, valid: true),
      LocaleCombination(merchantLocale: frFrLocale, consumerLocale: jpJPLocale, valid: false),
    ]

    for combination in localeCombinations {
      Afterpay.setConfiguration(
        // swiftlint:disable:next force_try
        try! Configuration(
          minimumAmount: one,
          maximumAmount: oneThousand,
          currencyCode: usdCode,
          locale: combination.merchantLocale,
          environment: .sandbox,
          consumerLocale: combination.consumerLocale
        )
      )

      XCTAssertEqual(
        Afterpay.enabled,
        combination.valid,
        "Merchant: \(combination.merchantLocale), Consumer: \(combination.consumerLocale)"
      )
    }
  }
}
