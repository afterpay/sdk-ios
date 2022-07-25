//
//  IntroText.swift
//  Afterpay
//
//  Created by Scott Antonac on 25/8/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public enum AfterpayIntroText: String {
  case empty
  case make
  case makeTitle
  case pay
  case payTitle
  case `in`
  case inTitle
  case or
  case orTitle
  case payIn
  case payInTitle

  public var localizedText: String {
    switch self {
    case .empty: return ""
    case .make:
      return Afterpay.string.localized.intro.make
    case .makeTitle:
      return Afterpay.string.localized.intro.makeTitle
    case .pay:
      return Afterpay.string.localized.intro.pay
    case .payTitle:
      return Afterpay.string.localized.intro.payTitle
    case .in:
      return Afterpay.string.localized.intro.in
    case .inTitle:
      return Afterpay.string.localized.intro.inTitle
    case .or:
      return Afterpay.string.localized.intro.or
    case .orTitle:
      return Afterpay.string.localized.intro.orTitle
    case .payIn:
      return Afterpay.string.localized.intro.payIn
    case .payInTitle:
      return Afterpay.string.localized.intro.payInTitle
    }
  }
}
