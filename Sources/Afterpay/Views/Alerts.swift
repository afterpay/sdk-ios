//
//  Alerts.swift
//  Afterpay
//
//  Created by Adam Campbell on 22/12/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

enum Alerts {

  static func failedToLoad(
    retry: @escaping () -> Void,
    cancel: @escaping () -> Void
  ) -> UIAlertController {
    let alert = UIAlertController(
      title: NSLocalizedString(
        "Error",
        comment: "Error dialog title"
      ),
      message: NSLocalizedString(
        "Failed to load Afterpay checkout",
        comment: "Error dialog for checkout not loaded"
      ),
      preferredStyle: .alert
    )

    let retryHandler: (UIAlertAction) -> Void = { _ in retry() }
    let cancelHandler: (UIAlertAction) -> Void = { _ in cancel() }

    let actions = [
      UIAlertAction(title: NSLocalizedString(
        "Retry",
        comment: "Error dialog response: Retry"
      ), style: .default, handler: retryHandler),
      UIAlertAction(title: NSLocalizedString(
        "Cancel",
        comment: "Error dialog response: Cancel"
      ), style: .destructive, handler: cancelHandler),
    ]

    actions.forEach(alert.addAction)

    return alert
  }

  static func areYouSureYouWantToCancel(cancel: @escaping () -> Void) -> UIAlertController {
    let actionSheet = UIAlertController(
      title: NSLocalizedString(
        "Are you sure you want to cancel the payment?",
        comment: "Question for dialog: are you sure?"
      ),
      message: nil,
      preferredStyle: UIDevice.current.userInterfaceIdiom == .phone ? .actionSheet : .alert
    )

    let cancelHandler: (UIAlertAction) -> Void = { _ in cancel() }

    let actions = [
      UIAlertAction(title: NSLocalizedString(
        "Yes",
        comment: "Are you sure response: yes"
      ), style: .destructive, handler: cancelHandler),
      UIAlertAction(title: NSLocalizedString(
        "No",
        comment: "Are you sure response: no"
      ), style: .cancel, handler: nil),
    ]

    actions.forEach(actionSheet.addAction)

    return actionSheet
  }

}
