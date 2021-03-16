//
//  SubtitleLabel.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 16/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class SubtitleLabel: UILabel {
  init(title: String, merchantName: String? = nil, fontSize: CGFloat = 14) {
    super.init(frame: .zero)

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineHeightMultiple = 1.34
    lineBreakMode = .byWordWrapping

    let regularTextFont = UIFont.afterPayFont(weight: .regular, size: fontSize)
    let boldTextFont = UIFont.afterPayFont(weight: .bold, size: fontSize)

    let prefix = NSMutableAttributedString(
      string: title,
      attributes: [
        .font: UIFontMetrics(forTextStyle: .title3).scaledFont(for: regularTextFont),
        .paragraphStyle: paragraphStyle,
      ]
    )

    if let merchantName = merchantName {
      let suffix = NSMutableAttributedString(
        string: merchantName,
        attributes: [
          .font: UIFontMetrics(forTextStyle: .title3).scaledFont(for: boldTextFont),
          .paragraphStyle: paragraphStyle,
        ]
      )

      prefix.append(suffix)

    }

    attributedText = prefix
    numberOfLines = 0

    adjustsFontForContentSizeCategory = true
    translatesAutoresizingMaskIntoConstraints = false
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
