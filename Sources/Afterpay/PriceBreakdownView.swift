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

  private let label = UILabel()

  public init() {
    super.init(frame: .zero)

    sharedInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    sharedInit()
  }

  private func sharedInit() {
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 0

    if #available(iOS 13.0, *) {
      label.textColor = .label
    } else {
      label.textColor = .black
    }

    updateAttributedText()

    addSubview(label)

    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: leadingAnchor),
      label.topAnchor.constraint(equalTo: topAnchor),
      label.trailingAnchor.constraint(equalTo: trailingAnchor),
      label.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  private func updateAttributedText() {
    let svgView = SVGView(lightSVG: .badgeWhiteOnBlack, darkSVG: .badgeBlackOnWhite)
    let svg = svgView.svg

    let font: UIFont = .preferredFont(forTextStyle: .body)
    let fontHeight = font.ascender - font.descender

    let widthFittingFont = fontHeight / svg.aspectRatio
    let width = widthFittingFont > svg.minimumWidth ? widthFittingFont : svg.minimumWidth
    let size = CGSize(width: width, height: width * svg.aspectRatio)

    svgView.frame = CGRect(origin: .zero, size: size)

    let renderer = UIGraphicsImageRenderer(size: svgView.bounds.size)
    let image = renderer.image { rendererContext in
      svgView.layer.render(in: rendererContext.cgContext)
    }

    let attributedString = NSMutableAttributedString(
      string: "or 4 payments of $40.00 with ",
      attributes: [NSAttributedString.Key.font: font]
    )

    let badgeAttachment = NSTextAttachment()
    badgeAttachment.image = image
    badgeAttachment.bounds = CGRect(origin: .init(x: 0, y: font.descender), size: image.size)
    let badge = NSAttributedString(attachment: badgeAttachment)

    attributedString.append(badge)

    label.attributedText = attributedString
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
