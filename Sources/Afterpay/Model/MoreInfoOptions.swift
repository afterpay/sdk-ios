//
//  MoreInfoOptions.swift
//  Afterpay
//
//  Created by Scott Antonac on 31/1/22.
//  Copyright © 2022 Afterpay. All rights reserved.
//

import Foundation

public struct MoreInfoOptions {
  public var modalTheme: ModalTheme = .mint
  public var modalId: String?
  public var isCbtEnabled: Bool = false

  /**
  Set up options for the more info link in AfterpayPriceBreakdown

  - Parameter modalId: the filename of a modal hosted on Afterpay static
  */
  public init(modalId: String? = nil) {
    self.modalId = modalId
  }

  /**
  Set up options for the more info link in AfterpayPriceBreakdown

  **Notes:**
  - Not all combinations of Locales and CBT are available.

  - Parameter modalTheme: the color theme used when displaying the modal
  - Parameter isCbtEnabled: whether to show the Cross Border Trade details in the modal
  */
  public init(modalTheme: ModalTheme = .mint, isCbtEnabled: Bool = false) {
    self.modalTheme = modalTheme
    self.isCbtEnabled = isCbtEnabled
  }

  func modalFile() -> String {
    if self.modalId != nil {
      return "\(self.modalId!).html"
    }

    let locale = getConfiguration()?.locale.identifier ?? "en_US"
    let cbt = self.isCbtEnabled ? "-cbt":""
    let theme = self.modalTheme

    return "\(locale)\(theme.rawValue)\(cbt).html"
  }
}
