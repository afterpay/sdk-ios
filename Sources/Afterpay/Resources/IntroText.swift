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
      return NSLocalizedString(
        "MAKE",
        tableName: "Placement",
        bundle: Bundle.apResource,
        value: "make",
        comment: "Intro text for breakdown placement: 'make'"
      )
    case .makeTitle:
      return NSLocalizedString(
        "MAKE_TITLE",
        tableName: "Placement",
        bundle: Bundle.apResource,
        value: "Make",
        comment: "Intro text for breakdown placement: 'Make'"
      )
    case .pay:
      return NSLocalizedString(
        "PAY",
        tableName: "Placement",
        bundle: Bundle.apResource,
        value: "pay",
        comment: "Intro text for breakdown placement: 'pay'"
      )
    case .payTitle:
      return NSLocalizedString(
        "PAY_TITLE",
        tableName: "Placement",
        bundle: Bundle.apResource,
        value: "Pay",
        comment: "Intro text for breakdown placement: 'Pay'"
      )
    case .in:
      return NSLocalizedString(
        "IN",
        tableName: "Placement",
        bundle: Bundle.apResource,
        value: "in",
        comment: "Intro text for breakdown placement: 'in'"
      )
    case .inTitle:
      return NSLocalizedString(
        "IN_TITLE",
        tableName: "Placement",
        bundle: Bundle.apResource,
        value: "In",
        comment: "Intro text for breakdown placement: 'In'"
      )
    case .or:
      return NSLocalizedString(
        "OR",
        tableName: "Placement",
        bundle: Bundle.apResource,
        value: "or",
        comment: "Intro text for breakdown placement: 'or'"
      )
    case .orTitle:
      return NSLocalizedString(
        "OR_TITLE",
        tableName: "Placement",
        bundle: Bundle.apResource,
        value: "Or",
        comment: "Intro text for breakdown placement: 'Or'"
      )
    case .payIn:
      return NSLocalizedString(
        "PAY_IN",
        tableName: "Placement",
        bundle: Bundle.apResource,
        value: "pay in",
        comment: "Intro text for breakdown placement: 'pay in'"
      )
    case .payInTitle:
      return NSLocalizedString(
        "PAY_IN_TITLE",
        tableName: "Placement",
        bundle: Bundle.apResource,
        value: "Pay in",
        comment: "Intro text for breakdown placement: 'Pay in'"
      )
    }
  }
}
