//
//  AlertFactory.swift
//  Example
//
//  Created by Adam Campbell on 26/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

@objc final class AlertFactory: NSObject {

  @available(*, unavailable)
  override init() {}

  static func alert(for checkoutUrlError: Error) -> UIAlertController {
    let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))

    switch checkoutUrlError {
    case CheckoutError.malformedUrl:
      alert.message = "Invalid host and port settings"
    default:
      alert.message = "Failed to retrieve checkout url"
    }

    return alert
  }

  static func alert(for errorMessage: String) -> UIAlertController {
    let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
    alert.message = errorMessage
    return alert
  }

}
