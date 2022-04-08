//
//  MoreInfoText.swift
//  Afterpay
//
//  Created by Scott Antonac on 15/3/2022.
//  Copyright © 2022 Afterpay. All rights reserved.
//

import Foundation
import UIKit

internal struct ModalLinkConfig {
  var text: String?
  var image: UIImage?
  var imageRenderingMode: UIImage.RenderingMode?
  var customContent: NSAttributedString?
  var attributes: [NSAttributedString.Key: Any] = [:]
}

public enum ModalLinkStyle {
  case circledInfoIcon
  case moreInfoText
  case learnMoreText
  case circledQuestionIcon
  case circledLogo
  case custom(NSMutableAttributedString)
  case none

  var styleConfig: ModalLinkConfig {
    switch self {
    case .circledInfoIcon:
      return ModalLinkConfig(
        text: Strings.circledInfoIcon,
        attributes: [NSAttributedString.Key.underlineColor: UIColor.clear]
      )
    case .moreInfoText:
      return ModalLinkConfig(text: Strings.moreInfo)
    case .learnMoreText:
      return ModalLinkConfig(text: Strings.learnMore)
    case .circledQuestionIcon:
      return ModalLinkConfig(
        image: AfterpayAssetProvider.image(named: "circled-question-icon"),
        imageRenderingMode: .alwaysTemplate,
        attributes: [NSAttributedString.Key.underlineColor: UIColor.clear]
      )
    case .circledLogo:
      return ModalLinkConfig(
        image: AfterpayAssetProvider.image(named: "afterpay-logo-circle"),
        imageRenderingMode: .alwaysOriginal,
        attributes: [NSAttributedString.Key.underlineColor: UIColor.clear]
      )
    case .custom(let string):
      return ModalLinkConfig(
        customContent: string,
        attributes: [NSAttributedString.Key.underlineColor: UIColor.clear]
      )
    case .none:
      return ModalLinkConfig()
    }
  }
}
