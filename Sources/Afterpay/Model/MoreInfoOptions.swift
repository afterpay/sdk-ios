//
//  MoreInfoOptions.swift
//  Afterpay
//
//  Created by Scott Antonac on 31/1/22.
//  Copyright © 2022 Afterpay. All rights reserved.
//

import Foundation

public struct MoreInfoOptions {
  public var modalLinkStyle: ModalLinkStyle = .circledInfoIcon
  public var modalTheme: ModalTheme = .mint
  public var isCbtEnabled: Bool = false
  public var modalId: String?

  /**
  Set up options for the more info link in AfterpayPriceBreakdown

  - Parameter modalId: the filename of a modal hosted on Afterpay static
  */
  public init(
    modalId: String? = nil,
    modalLinkStyle: ModalLinkStyle = .circledInfoIcon
  ) {
    self.modalId = modalId
    self.modalLinkStyle = modalLinkStyle
  }

  /**
  Set up options for the more info link in AfterpayPriceBreakdown

  **Notes:**
  - Not all combinations of Locales and CBT are available.

  - Parameter modalTheme: the color theme used when displaying the modal
  - Parameter isCbtEnabled: whether to show the Cross Border Trade details in the modal
  */
  public init(
    modalTheme: ModalTheme = .mint,
    isCbtEnabled: Bool = false,
    modalLinkStyle: ModalLinkStyle = .circledInfoIcon
  ) {
    self.modalTheme = modalTheme
    self.isCbtEnabled = isCbtEnabled
    self.modalLinkStyle = modalLinkStyle
  }

  func modalFile() -> String {
    if self.modalId != nil {
      return "\(self.modalId!).html"
    }

    let languageLocale: Locale = Afterpay.language ?? Locales.enGB
    let locale = "\(languageLocale.languageCode ?? "en")_\(Afterpay.getLocale().regionCode ?? "US")"

    let cbt = self.isCbtEnabled ? "-cbt":""
    let theme = self.modalTheme

    return "\(locale)\(theme.rawValue)\(cbt).html"
  }
}
