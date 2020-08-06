//
//  PriceBreakdownView.swift
//  Afterpay
//
//  Created by Adam Campbell on 3/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public final class PriceBreakdownView: UIView {

  private let textView = UITextView()
  private let colorScheme: ColorScheme

  public init(colorScheme: ColorScheme = .static(.blackOnMint)) {
    self.colorScheme = colorScheme

    super.init(frame: .zero)

    sharedInit()
  }

  required init?(coder: NSCoder) {
    self.colorScheme = .static(.blackOnMint)

    super.init(coder: coder)

    sharedInit()
  }

  private func sharedInit() {
    textView.translatesAutoresizingMaskIntoConstraints = false
    textView.isScrollEnabled = false
    textView.textContainerInset = .zero
    textView.textContainer.lineFragmentPadding = .zero
    textView.layoutManager.usesFontLeading = false

    updateAttributedText()

    addSubview(textView)

    NSLayoutConstraint.activate([
      textView.leadingAnchor.constraint(equalTo: leadingAnchor),
      textView.topAnchor.constraint(equalTo: topAnchor),
      textView.trailingAnchor.constraint(equalTo: trailingAnchor),
      textView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  private func updateAttributedText() {
    let badgeSVGView = SVGView(svgPair: colorScheme.badgeSVGPair)
    let svg = badgeSVGView.svg

    let font: UIFont = .preferredFont(forTextStyle: .body)
    let fontHeight = font.ascender - font.descender

    let widthFittingFont = fontHeight / svg.aspectRatio
    let width = widthFittingFont > svg.minimumWidth ? widthFittingFont : svg.minimumWidth
    let size = CGSize(width: width, height: width * svg.aspectRatio)

    badgeSVGView.frame = CGRect(origin: .zero, size: size)

    let renderer = UIGraphicsImageRenderer(size: badgeSVGView.bounds.size)
    let image = renderer.image { rendererContext in
      badgeSVGView.layer.render(in: rendererContext.cgContext)
    }

    let textColor: UIColor = {
      if #available(iOS 13.0, *) {
        return .label
      } else {
        return .black
      }
    }()

    let attributedString = NSMutableAttributedString(
      string: "or 4 payments of $40.00 with ",
      attributes: [.font: font, .foregroundColor: textColor]
    )

    let badgeAttachment = NSTextAttachment()
    badgeAttachment.image = image
    badgeAttachment.bounds = CGRect(origin: .init(x: 0, y: font.descender), size: image.size)
    let badge = NSAttributedString(attachment: badgeAttachment)

    attributedString.append(badge)

    textView.attributedText = attributedString
  }

  public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)

    let userInterfaceStyle = traitCollection.userInterfaceStyle
    let previousUserInterfaceStyle = previousTraitCollection?.userInterfaceStyle
    let contentSizeCategory = traitCollection.preferredContentSizeCategory
    let previousContentSizeCategory = previousTraitCollection?.preferredContentSizeCategory

    let userInterfaceStyleChanged = previousUserInterfaceStyle != userInterfaceStyle
    let contentSizeCategoryChanged = previousContentSizeCategory != contentSizeCategory

    if userInterfaceStyleChanged || contentSizeCategoryChanged {
      updateAttributedText()
    }
  }

}
