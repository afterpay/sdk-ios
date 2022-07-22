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
    let localisedMessage = Afterpay.string.localised.alert.failedToLoadMessage

    let alert = UIAlertController(
      title: Afterpay.string.localised.alert.errorTitle,
      message: String.localizedStringWithFormat(localisedMessage, "Afterpay"),
      preferredStyle: .alert
    )

    let retryHandler: (UIAlertAction) -> Void = { _ in retry() }
    let cancelHandler: (UIAlertAction) -> Void = { _ in cancel() }

    let actions = [
      UIAlertAction(
        title: Afterpay.string.localised.alert.retryAction,
        style: .default,
        handler: retryHandler
      ),
      UIAlertAction(
        title: Afterpay.string.localised.alert.cancelAction,
        style: .destructive,
        handler: cancelHandler
      ),
    ]

    actions.forEach(alert.addAction)

    return alert
  }

  static func areYouSureYouWantToCancel(cancel: @escaping () -> Void) -> UIAlertController {
    let actionSheet = UIAlertController(
      title: Afterpay.string.localised.alert.cancelPaymentTitle,
      message: nil,
      preferredStyle: UIDevice.current.userInterfaceIdiom == .phone ? .actionSheet : .alert
    )

    let cancelHandler: (UIAlertAction) -> Void = { _ in cancel() }

    let actions = [
      UIAlertAction(
        title: Afterpay.string.localised.alert.yesAction,
        style: .destructive,
        handler: cancelHandler
      ),
      UIAlertAction(
        title: Afterpay.string.localised.alert.noAction,
        style: .cancel,
        handler: nil
      ),
    ]

    actions.forEach(actionSheet.addAction)

    return actionSheet
  }

}
