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
      return Afterpay.string.localised.intro.make
    case .makeTitle:
      return Afterpay.string.localised.intro.makeTitle
    case .pay:
      return Afterpay.string.localised.intro.pay
    case .payTitle:
      return Afterpay.string.localised.intro.payTitle
    case .in:
      return Afterpay.string.localised.intro.in
    case .inTitle:
      return Afterpay.string.localised.intro.inTitle
    case .or:
      return Afterpay.string.localised.intro.or
    case .orTitle:
      return Afterpay.string.localised.intro.orTitle
    case .payIn:
      return Afterpay.string.localised.intro.payIn
    case .payInTitle:
      return Afterpay.string.localised.intro.payInTitle
    }
  }
}
