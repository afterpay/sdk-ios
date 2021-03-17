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
    print("on ready")
  }

  func onChanged(status: WidgetStatus) {
    print("on changed")
  }

  func onError(errorCode: String, message: String) {
    print("on error")
  }

  func onFailure(error: Error) {
    print("Internal error occurred in the SDK: \(error.localizedDescription)")
  }

}
