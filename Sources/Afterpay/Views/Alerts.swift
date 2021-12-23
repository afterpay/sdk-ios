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
    let localisedMessage = NSLocalizedString(
      "FAILED_TO_LOAD_MESAGE",
      tableName: "Alerts",
      bundle: Afterpay.bundle,
      value: "Failed to load %@ checkout",
      comment: "Error dialog for checkout not loaded"
    )

    let alert = UIAlertController(
      title: NSLocalizedString(
        "ERROR_TITLE",
        tableName: "Alerts",
        bundle: Afterpay.bundle,
        value: "Error",
        comment: "Error dialog title"
      ),
      message: String.localizedStringWithFormat(localisedMessage, "Afterpay"),
      preferredStyle: .alert
    )

    let retryHandler: (UIAlertAction) -> Void = { _ in retry() }
    let cancelHandler: (UIAlertAction) -> Void = { _ in cancel() }

    let actions = [
      UIAlertAction(
        title: NSLocalizedString(
          "RETRY_ACTION",
          tableName: "Alerts",
          bundle: Afterpay.bundle,
          value: "Retry",
          comment: "Error dialog response: Retry"
        ),
        style: .default,
        handler: retryHandler
      ),
      UIAlertAction(
        title: NSLocalizedString(
          "CANCEL_ACTION",
          tableName: "Alerts",
          bundle: Afterpay.bundle,
          value: "Cancel",
          comment: "Error dialog response: Cancel"
        ),
        style: .destructive,
        handler: cancelHandler
      ),
    ]

    actions.forEach(alert.addAction)

    return alert
  }

  static func areYouSureYouWantToCancel(cancel: @escaping () -> Void) -> UIAlertController {
    let actionSheet = UIAlertController(
      title: NSLocalizedString(
        "CANCEL_PAYMENT_TITLE",
        tableName: "Alerts",
        bundle: Afterpay.bundle,
        value: "Are you sure you want to cancel the payment?",
        comment: "Question for dialog: are you sure?"
      ),
      message: nil,
      preferredStyle: UIDevice.current.userInterfaceIdiom == .phone ? .actionSheet : .alert
    )

    let cancelHandler: (UIAlertAction) -> Void = { _ in cancel() }

    let actions = [
      UIAlertAction(
        title: NSLocalizedString(
          "YES_ACTION",
          tableName: "Alerts",
          bundle: Afterpay.bundle,
          value: "Yes",
          comment: "Alert action (button): yes"
        ),
        style: .destructive,
        handler: cancelHandler
      ),
      UIAlertAction(
        title: NSLocalizedString(
          "NO_ACTION",
          tableName: "Alerts",
          bundle: Afterpay.bundle,
          value: "No",
          comment: "Alert action (button): no"
        ),
        style: .cancel,
        handler: nil
      ),
    ]

    actions.forEach(actionSheet.addAction)

    return actionSheet
  }

}
