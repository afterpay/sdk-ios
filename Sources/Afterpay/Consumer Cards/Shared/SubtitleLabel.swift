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
  init(with title: String) {
    super.init(frame: .zero)

    text = title
    numberOfLines = 0

    let textFont = UIFont.systemFont(ofSize: 14, weight: .regular)
    adjustsFontForContentSizeCategory = true
    font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: textFont)

    translatesAutoresizingMaskIntoConstraints = false
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
