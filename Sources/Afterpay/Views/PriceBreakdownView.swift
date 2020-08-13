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

  public var totalAmount: Decimal = .zero {
    didSet {
      updateAttributedText()
    }
  }

  private let linkTextView = LinkTextView()
  private var textColor: UIColor!
  private var linkColor: UIColor!
  private let colorScheme: ColorScheme

  private var termsLink: String {
    switch getLocale() {
    case Locales.australia:
      return "https://static-us.afterpay.com/javascript/modal/au_rebrand_modal.html"
    case Locales.newZealand:
      return "https://static-us.afterpay.com/javascript/modal/nz_rebrand_modal.html"
    case Locales.canada:
      return "https://static-us.afterpay.com/javascript/modal/ca_rebrand_modal.html"
    default:
      return "https://static-us.afterpay.com/javascript/modal/us_rebrand_modal.html"
    }
  }

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
      linkColor = .secondaryLabel
    } else {
      textColor = .black
      linkColor = UIColor(red: 60 / 255, green: 60 / 255, blue: 67 / 255, alpha: 0.6)
    }

    linkTextView.linkTextAttributes = [
      .underlineStyle: NSUnderlineStyle.single.rawValue,
      .foregroundColor: linkColor as Any,
    ]

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

    let selector = #selector(updateAttributedText)
    let name: NSNotification.Name = .configurationUpdated
    notificationCenter.addObserver(self, selector: selector, name: name, object: nil)
  }

  @objc private func updateAttributedText() {
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

    let attributedString = NSMutableAttributedString()

    let badge: NSAttributedString = {
      let attachment = NSTextAttachment()
      attachment.image = image
      attachment.bounds = CGRect(origin: .init(x: 0, y: font.descender), size: image.size)
      attachment.accessibilityLabel = Strings.accessibleAfterpay
      return .init(attachment: attachment)
    }()

    let space = NSAttributedString(string: " ", attributes: textAttributes)

    let priceBreakdown = PriceBreakdown(totalAmount: totalAmount)
    let breakdown = NSAttributedString(string: priceBreakdown.string, attributes: textAttributes)

    let badgePlacement = priceBreakdown.badgePlacement
    var badgeAndBreakdown = [badge, space, breakdown]
    badgeAndBreakdown = badgePlacement == .start ? badgeAndBreakdown : badgeAndBreakdown.reversed()

    let linkAttributes = textAttributes.merging([.link: termsLink]) { $1 }
    let link = NSAttributedString(string: Strings.info, attributes: linkAttributes)
    let strings = badgeAndBreakdown + [space, link]

    strings.forEach(attributedString.append)

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
