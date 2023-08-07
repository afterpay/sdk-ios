//
//  Drawables.swift
//  Afterpay
//
//  Created by Scott Antonac on 25/7/2022.
//  Copyright © 2022 Afterpay. All rights reserved.
//

import Foundation

private let localeLanguages: [Locale: Drawables] = [
  Locales.enAU: .enAfterpay,
  Locales.enGB: .enClearpay,
  Locales.enNZ: .enAfterpay,
  Locales.enUS: .enAfterpay,
  Locales.enUSposix: .enAfterpay,
  Locales.enCA: .enAfterpay,
  Locales.frCA: .frCA,
]

enum Drawables {

  case enAfterpay
  case enClearpay
  case frCA
  case fr
  case it
  case es

  internal static func forLocale() -> Drawables {
    return localeLanguages[Afterpay.language ?? Locales.enAU] ?? .enAfterpay
  }

  internal var localized: LocalizedDrawable {
    switch self {
    case .enAfterpay:
      return LocalizedDrawable(
        buttonBuyNowForeground: "button-foreground-buy-now-afterpay-en",
        buttonCheckoutForeground: "button-foreground-checkout-afterpay-en",
        buttonPayNowForeground: "button-foreground-pay-now-afterpay-en",
        buttonPlaceOrderForeground: "button-foreground-place-order-afterpay-en"
      )
    case .enClearpay:
      return LocalizedDrawable(
        buttonBuyNowForeground: "button-foreground-buy-now-clearpay-en",
        buttonCheckoutForeground: "button-foreground-checkout-clearpay-en",
        buttonPayNowForeground: "button-foreground-pay-now-clearpay-en",
        buttonPlaceOrderForeground: "button-foreground-place-order-clearpay-en"
      )
    case .frCA:
      return LocalizedDrawable(
        buttonBuyNowForeground: "button-foreground-buy-now-afterpay-frCa",
        buttonCheckoutForeground: "button-foreground-checkout-afterpay-frCa",
        buttonPayNowForeground: "button-foreground-pay-now-afterpay-frCa",
        buttonPlaceOrderForeground: "button-foreground-place-order-afterpay-frCa"
      )
    case .fr:
      return LocalizedDrawable(
        buttonBuyNowForeground: "button-foreground-buy-now-clearpay-fr",
        buttonCheckoutForeground: "button-foreground-checkout-clearpay-fr",
        buttonPayNowForeground: "button-foreground-pay-now-clearpay-fr",
        buttonPlaceOrderForeground: "button-foreground-place-order-clearpay-fr"
      )
    case .it:
      return LocalizedDrawable(
        buttonBuyNowForeground: "button-foreground-buy-now-clearpay-it",
        buttonCheckoutForeground: "button-foreground-checkout-clearpay-it",
        buttonPayNowForeground: "button-foreground-pay-now-clearpay-it",
        buttonPlaceOrderForeground: "button-foreground-place-order-clearpay-it"
      )
    case .es:
      return LocalizedDrawable(
        buttonBuyNowForeground: "button-foreground-buy-now-clearpay-es",
        buttonCheckoutForeground: "button-foreground-checkout-clearpay-es",
        buttonPayNowForeground: "button-foreground-pay-now-clearpay-es",
        buttonPlaceOrderForeground: "button-foreground-place-order-clearpay-es"
      )
    }
  }
}

internal struct LocalizedDrawable {
  let buttonBuyNowForeground: String
  let buttonCheckoutForeground: String
  let buttonPayNowForeground: String
  let buttonPlaceOrderForeground: String
}
