//
//  PriceBreakdownView.swift
//  Afterpay
//
//  Created by Adam Campbell on 3/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

/// Implementing this delegate protocol allows launching of the info link modally in app.
public protocol PriceBreakdownViewDelegate: AnyObject {

  /// The view controller for which the modal info web view controller should be presented on.
  /// - Returns: The view controller for modal presentation.
  func viewControllerForPresentation() -> UIViewController

}

/// A view that displays informative text, the Afterpay badge and an info link. The info link will
/// launch externally by default but can launch modally in app by implementing
/// PriceBreakdownViewDelegate. This view updates in response to Afterpay configuration changes
/// as well as changes to the `totalAmount`.
public final class PriceBreakdownView: UIView {

  /// The price breakdown view delegate. Not setting this delegate will cause the info link to open
  /// externally.
  public weak var delegate: PriceBreakdownViewDelegate?

  /// The total amount of the product or cart being viewed as a Swift Decimal. This Decimal
  /// conversion should be done from a lossless source. e.g. a String.
  public var totalAmount: Decimal = .zero {
    didSet {
      updateAttributedText()
    }
  }

  public var introText: AfterpayIntroText = AfterpayIntroText.or {
    didSet {
      updateAttributedText()
    }
  }

  public var showWithText: Bool = true {
    didSet {
      updateAttributedText()
    }
  }

  public var showInterestFreeText: Bool = true {
    didSet {
      updateAttributedText()
    }
  }

  public var textColor: UIColor = {
    if #available(iOS 13.0, *) {
      return .label
    } else {
      return .black
    }
  }()

  public var linkColor: UIColor = {
    if #available(iOS 13.0, *) {
      return .secondaryLabel
    } else {
      return UIColor(red: 60 / 255, green: 60 / 255, blue: 67 / 255, alpha: 0.6)
    }
  }()

  public var badgeColorScheme: ColorScheme = .static(.blackOnMint) {
    didSet { updateAttributedText() }
  }

  public var fontProvider: (UITraitCollection) -> UIFont = { traitCollection in
    .preferredFont(forTextStyle: .body, compatibleWith: traitCollection)
  }

  public var moreInfoOptions: MoreInfoOptions = MoreInfoOptions() {
    didSet { updateAttributedText() }
  }

  private let linkTextView = LinkTextView()

  private var infoLink: String {
    return "https://static.afterpay.com/modal/\(self.moreInfoOptions.modalFile())"
  }

  public init(badgeColorScheme: ColorScheme = .static(.blackOnMint)) {
    self.badgeColorScheme = badgeColorScheme

    super.init(frame: .zero)

    sharedInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    sharedInit()
  }

  private func sharedInit() {
    linkTextView.linkHandler = { [weak self] url in
      if let viewController = self?.delegate?.viewControllerForPresentation() {
        let infoWebViewController = InfoWebViewController(infoURL: url)
        let navigationController = UINavigationController(rootViewController: infoWebViewController)
        viewController.present(navigationController, animated: true, completion: nil)
      } else {
        UIApplication.shared.open(url)
      }
    }

    addSubview(linkTextView)

    NSLayoutConstraint.activate([
      linkTextView.leadingAnchor.constraint(equalTo: leadingAnchor),
      linkTextView.topAnchor.constraint(equalTo: topAnchor),
      linkTextView.trailingAnchor.constraint(equalTo: trailingAnchor),
      linkTextView.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])

    let selector = #selector(configurationDidChange)
    let name: NSNotification.Name = .configurationUpdated
    notificationCenter.addObserver(self, selector: selector, name: name, object: nil)
  }

  @objc private func configurationDidChange() {
    DispatchQueue.main.async {
      self.updateAttributedText()
    }
  }

  private func updateAttributedText() {
    let configuration = BadgeConfiguration(colorScheme: badgeColorScheme)
    let badgeView = BadgeView(colorScheme: .dynamic(lightPalette: .mintOnBlack, darkPalette: .blackOnWhite))

    let font: UIFont = fontProvider(traitCollection)
    let fontHeight = font.ascender - font.descender

    let badgeRatio = badgeView.ratio ?? 1

    let widthFittingFont = fontHeight / badgeRatio
    let width = widthFittingFont > badgeView.minimumWidth ? widthFittingFont : badgeView.minimumWidth
    let size = CGSize(width: width, height: width * badgeRatio)

    badgeView.frame = CGRect(origin: .zero, size: size)

    let image = badgeView.image

    let textAttributes: [NSAttributedString.Key: Any] = [
      .font: font,
      .foregroundColor: textColor as UIColor,
    ]

    linkTextView.linkTextAttributes = [
      .underlineStyle: NSUnderlineStyle.single.rawValue,
      .foregroundColor: linkColor,
    ]

    let attributedString = NSMutableAttributedString()

    let badge: NSAttributedString = {
      let attachment = NSTextAttachment()
      attachment.image = image
      attachment.bounds = CGRect(origin: .init(x: 0, y: font.descender), size: badgeView.bounds.size)
      attachment.accessibilityLabel = configuration.accessibilityLabel(localizedFor: getLocale())
      return .init(attachment: attachment)
    }()

    let space = NSAttributedString(string: " ", attributes: textAttributes)

    let priceBreakdown = PriceBreakdown(
      totalAmount: totalAmount,
      introText: introText,
      showInterestFreeText: showInterestFreeText,
      showWithText: showWithText
    )
    let breakdown = NSAttributedString(string: priceBreakdown.string, attributes: textAttributes)

    let badgePlacement = priceBreakdown.badgePlacement
    var badgeAndBreakdown = [badge, space, breakdown]
    badgeAndBreakdown = badgePlacement == .start ? badgeAndBreakdown : badgeAndBreakdown.reversed()

    let linkAttributes = textAttributes.merging([.link: infoLink]) { $1 }
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
