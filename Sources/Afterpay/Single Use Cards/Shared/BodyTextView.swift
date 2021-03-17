//
//  BodyTextView.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 11/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class BodyTextView: UITextView {

  let textFont: UIFont
  let paragraphStyle: NSMutableParagraphStyle
  let fontSize: CGFloat = 14

  override init(frame: CGRect, textContainer: NSTextContainer?) {
    self.textFont = UIFontMetrics(forTextStyle: .footnote)
      .scaledFont(for: UIFont.afterPayFont(weight: .regular, size: fontSize))
    self.paragraphStyle = NSMutableParagraphStyle()

    super.init(frame: frame, textContainer: textContainer)

    adjustsFontForContentSizeCategory = true
    translatesAutoresizingMaskIntoConstraints = false
    isEditable = false
    isSelectable = true
    isScrollEnabled = false
    textContainerInset = .zero

    self.textContainer.lineFragmentPadding = .zero
    self.textContainer.lineBreakMode = .byWordWrapping
  }

  required init?(coder: NSCoder) {
    self.textFont = UIFontMetrics(forTextStyle: .footnote)
      .scaledFont(for: UIFont.afterPayFont(weight: .regular, size: fontSize))
    self.paragraphStyle = NSMutableParagraphStyle()

    super.init(coder: coder)
  }

  func configure(with text: String, lineHeightMultiple: CGFloat = 1.34) {
    paragraphStyle.lineHeightMultiple = lineHeightMultiple

    let attributedString = NSMutableAttributedString(
      string: text,
      attributes: [
        .font: textFont,
        .paragraphStyle: paragraphStyle,
      ]
    )

    attributedText = attributedString
  }

  func addHyperlink(title: String, link: String) {
    let attributedString = NSMutableAttributedString(attributedString: attributedText)

    let range = (attributedString.string as NSString).range(of: title)
    attributedString.addAttribute(.link, value: link, range: range)

    attributedText = attributedString
  }
}
