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

    let regularTextFont = UIFont.systemFont(ofSize: fontSize, weight: .regular)
    let boldTextFont = UIFont.systemFont(ofSize: fontSize, weight: .bold)
 
    let prefix = NSMutableAttributedString(
      string: title,
      attributes: [
        .font: UIFontMetrics(forTextStyle: .title3).scaledFont(for: regularTextFont),
      ]
    )
 
    if let merchantName = merchantName {
      let suffix = NSMutableAttributedString(
        string: merchantName,
        attributes: [
          .font: UIFontMetrics(forTextStyle: .title3).scaledFont(for: boldTextFont),
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
