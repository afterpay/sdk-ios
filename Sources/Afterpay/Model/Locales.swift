//
//  Locales.swift
//  Afterpay
//
//  Created by Adam Campbell on 13/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

enum Locales {

  static let australia = Locale(identifier: "en_AU")
  static let canada = Locale(identifier: "en_CA")
  static let greatBritain = Locale(identifier: "en_GB")
  static let newZealand = Locale(identifier: "en_NZ")
  static let posix = Locale(identifier: "en_US_POSIX")
  static let unitedStates = Locale(identifier: "en_US")

  static let validSet: Set<Locale> = [
    australia,
    canada,
    greatBritain,
    newZealand,
    unitedStates,
  ]

}
