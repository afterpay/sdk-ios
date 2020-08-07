//
//  PriceBreakdownView.swift
//  Afterpay
//
//  Created by Adam Campbell on 3/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public protocol PriceBreakdownViewDelegate: AnyObject {
  func viewControllerForPresentation() -> UIViewController
}

public final class PriceBreakdownView: UIView {

  public weak var delegate: PriceBreakdownViewDelegate?

  private let linkTextView = LinkTextView()
  private var textColor: UIColor!
  private var linkTintColor: UIColor!
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
    if #available(iOS 13.0, *) {
      textColor = .label
      linkTintColor = .secondaryLabel
    } else {
      textColor = .black
      linkTintColor = UIColor(red: 60 / 255, green: 60 / 255, blue: 67 / 255, alpha: 0.6)
    }

    linkTextView.tintColor = linkTintColor

    linkTextView.linkHandler = { [weak self] url in
      if let viewController = self?.delegate?.viewControllerForPresentation() {
        let infoWebViewController = InfoWebViewController(infoURL: url)
        let navigationController = UINavigationController(rootViewController: infoWebViewController)
        viewController.present(navigationController, animated: true, completion: nil)
      } else {
        UIApplication.shared.open(url)
      }
    }

    updateAttributedText()

    addSubview(linkTextView)

    NSLayoutConstraint.activate([
      linkTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
      linkTextView.topAnchor.constraint(equalTo: topAnchor),
      linkTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
      linkTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
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

    let textAttributes: [NSAttributedString.Key: Any] = [
      .font: font,
      .foregroundColor: textColor as UIColor,
    ]

    let attributedString = NSMutableAttributedString(
      string: "or 4 payments of $40.00 with ",
      attributes: textAttributes
    )

    let badgeAttachment = NSTextAttachment()
    badgeAttachment.image = image
    badgeAttachment.bounds = CGRect(origin: .init(x: 0, y: font.descender), size: image.size)
    attributedString.append(.init(attachment: badgeAttachment))

    attributedString.append(.init(string: " ", attributes: textAttributes))

    var linkAttributes = textAttributes
    linkAttributes[.link] = "https://static-us.afterpay.com/javascript/modal/us_modal.html"
    linkAttributes[.underlineStyle] = NSUnderlineStyle.single.rawValue

    attributedString.append(.init(string: "Info", attributes: linkAttributes))

    linkTextView.attributedText = attributedString
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
