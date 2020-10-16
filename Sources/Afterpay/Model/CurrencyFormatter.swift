//
//  CurrencyFormatter.swift
//  Afterpay
//
//  Created by Adam Campbell on 16/10/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

private let formatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.numberStyle = .currency
  return formatter
}()

struct CurrencyFormatter {

  let locale: Locale

  func string(from decimal: Decimal) -> String? {
    formatter.string(from: decimal as NSDecimalNumber)
  }

}
