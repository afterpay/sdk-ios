//
//  TitleLabel.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 16/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class TitleLabel: UILabel {

  init(with title: String, fontSize: CGFloat = 32) {
    super.init(frame: .zero)

    text = title
    numberOfLines = 0

    let textFont = UIFont.systemFont(ofSize: fontSize, weight: .bold)
    adjustsFontForContentSizeCategory = true
    font = UIFontMetrics(forTextStyle: .largeTitle).scaledFont(for: textFont)

    translatesAutoresizingMaskIntoConstraints = false
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
