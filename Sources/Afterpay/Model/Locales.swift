//
//  Locales.swift
//  Afterpay
//
//  Created by Adam Campbell on 13/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

enum Locales: Hashable {

  static let enAU = Locale(identifier: "en_AU")
  static let enCA = Locale(identifier: "en_CA")
  static let frCA = Locale(identifier: "fr_CA")
  static let enGB = Locale(identifier: "en_GB")
  static let enNZ = Locale(identifier: "en_NZ")
  static let enUS = Locale(identifier: "en_US")
  static let enUSposix = Locale(identifier: "en_US_POSIX")

  static let validArray: [Locale] = [
    enAU,
    enCA,
    frCA,
    enGB,
    enNZ,
    enUS,
  ]
}

private let validRegionLanguages = [
  Locales.enAU.regionCode!: [Locales.enAU],
  Locales.enCA.regionCode!: [Locales.enCA, Locales.frCA],
  Locales.enGB.regionCode!: [Locales.enGB],
  Locales.enNZ.regionCode!: [Locales.enNZ],
  Locales.enUS.regionCode!: [Locales.enUS],
]

internal func getRegionLanguage(merchantLocale: Locale, clientLocale: Locale) -> Locale? {
  return validRegionLanguages[merchantLocale.regionCode!]!.first {
    $0.languageCode == clientLocale.languageCode
  }
}
