//
//  OptionalText.swift
//  Afterpay
//
//  Created by Scott Antonac on 9/12/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public enum AfterpayOptionalText {
  case none
  case interestFree
  case with
  case interestFreeAndWith

  var stringValue: String {
    switch self {
    case .none:
      return Strings.fourPaymentsFormatNoOptional
    case .interestFree:
      return Strings.fourPaymentsFormatInterest
    case .with:
      return Strings.fourPaymentsFormatWith
    case .interestFreeAndWith:
      return Strings.fourPaymentsFormatInterestAndWith
    }
  }
}
