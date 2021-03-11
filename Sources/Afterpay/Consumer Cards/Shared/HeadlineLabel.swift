//
//  HeadlineLabel.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 11/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class HeadlineLabel: UILabel {
  override init(frame: CGRect) {
    super.init(frame: frame)

    textAlignment = .left
    numberOfLines = 0

    font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: UIFont.afterPayFont(weight: .bold, size: 14))

    adjustsFontForContentSizeCategory = true
    translatesAutoresizingMaskIntoConstraints = false
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
