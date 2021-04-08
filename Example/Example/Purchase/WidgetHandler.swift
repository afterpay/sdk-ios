//
//  WidgetHandler.swift
//  Example
//
//  Created by Huw Rowlands on 16/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Afterpay

final class WidgetEventHandler: WidgetHandler {

  func onReady(isValid: Bool, amountDueToday: Money, paymentScheduleChecksum: String?) {
    print(
      "READY: valid: \(isValid), amount due: \(amountDueToday), checksum: \(paymentScheduleChecksum ?? "no checksum")"
    )
  }

  func onChanged(status: WidgetStatus) {
    print("CHANGED: new status: \(status)")
  }

  func onError(errorCode: String?, message: String?) {
    print("ERROR: code \(errorCode ?? "null"), message: \(message ?? "null")")
  }

  func onFailure(error: Error) {
    print("Internal error occurred in the SDK: \(error.localizedDescription)")
  }

}
