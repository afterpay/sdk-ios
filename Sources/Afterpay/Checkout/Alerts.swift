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
      title: "Error",
      message: "Failed to load Afterpay checkout",
      preferredStyle: .alert
    )

    let retryHandler: (UIAlertAction) -> Void = { _ in retry() }
    let cancelHandler: (UIAlertAction) -> Void = { _ in cancel() }

    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: retryHandler))
    alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: cancelHandler))

    return alert
  }

}
