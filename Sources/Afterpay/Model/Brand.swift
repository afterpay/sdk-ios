//
//  Brand.swift
//  Afterpay
//
//  Created by Scott Antonac on 25/3/2022.
//  Copyright © 2022 Afterpay. All rights reserved.
//

import Foundation

private let clearpayLocales: Set<Locale> = [
  Locales.enGB,
]
private let afterpayLocales: Set<Locale> = [
  Locales.enAU,
  Locales.enCA,
  Locales.frCA,
  Locales.enNZ,
]

private let cashAppAfterpayLocales: Set<Locale> = [
  Locales.enUS,
  Locales.enUSposix,
]

private let brandLocales: [Set<Locale>: Brand] = [
  clearpayLocales: Brand.clearpay,
  afterpayLocales: Brand.afterpay,
  cashAppAfterpayLocales: Brand.cashAppAfterpay,
]

internal struct BrandDetails {
  let name: String
  let accessibleName: String
  let lowerCaseName: String
}

internal enum Brand {
  case afterpay
  case clearpay
  case cashAppAfterpay

  public var details: BrandDetails {
    switch self {
    case .afterpay:
      return BrandDetails(
        name: "Afterpay",
        accessibleName: Strings.accessibleAfterpay,
        lowerCaseName: "afterpay"
      )
    case .clearpay:
      return BrandDetails(
        name: "Clearpay",
        accessibleName: Strings.accessibleClearpay,
        lowerCaseName: "clearpay"
      )
    case .cashAppAfterpay:
      return BrandDetails(
        name: "CashAppAfterpay",
        accessibleName: Strings.accessibleCashAppAfterpay,
        lowerCaseName: "cashappafterpay"
      )
    }
  }

  public var isCashAppAfterpayRegion: Bool {
    return self == .cashAppAfterpay
  }

  static func forLocale(locale: Locale) -> Brand {
    return brandLocales.first(where: { (key, _) in
      key.contains(locale)
    })?.value ?? Brand.afterpay
  }
}
