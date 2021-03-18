//
//  WidgetHandler.swift
//  Example
//
//  Created by Huw Rowlands on 16/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Afterpay

final class WidgetEventHandler: WidgetHandler {

  func onReady(isValid: Bool, amountDueToday: Money, paymentScheduleChecksum: String) {
    print("On ready: valid: \(isValid), amount due: \(amountDueToday), checksum: \(paymentScheduleChecksum)")
  }

  func onChanged(status: WidgetStatus) {
    print("On changed: new status: \(status)")
  }

  func onError(errorCode: String?, message: String?) {
    print("On error: code \(errorCode ?? "null"), message: \(message ?? "null")")
  }

  func onFailure(error: Error) {
    print("Internal error occurred in the SDK: \(error.localizedDescription)")
  }

}
