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

  @available(*, deprecated, renamed: "logoColorScheme")
  public var badgeColorScheme: ColorScheme = .static(.blackOnMint)

  public var logoColorScheme: ColorScheme = .static(.blackOnMint) {
    didSet { updateAttributedText() }
  }

  public enum LogoType {
    case badge
    case lockup

    var heightMultiplier: Double {
      switch self {
      case .badge:
        return 1.8
      case .lockup:
        return 1
      }
    }

    var descenderMultiplier: Double {
      switch self {
      case .badge:
        return 1
      case .lockup:
        return 1.2
      }
    }
  }

  public var logoType: LogoType = .badge {
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

  @available(*, deprecated, renamed: "init(logoColorScheme:)")
  public init(badgeColorScheme: ColorScheme) {
    self.logoColorScheme = badgeColorScheme

    super.init(frame: .zero)

    sharedInit()
  }

  public init(logoColorScheme: ColorScheme = .static(.blackOnMint)) {
    self.logoColorScheme = logoColorScheme

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
    let logoView: AfterpayLogo
    if logoType == .lockup {
      logoView = LockupView(colorScheme: logoColorScheme)
    } else {
      logoView = BadgeView(colorScheme: logoColorScheme)
    }

    let font: UIFont = fontProvider(traitCollection)
    let fontHeight = font.ascender - font.descender
    let logoHeight = fontHeight * logoType.heightMultiplier

    let logoRatio = logoView.ratio ?? 1

    let widthFittingFont = logoHeight / logoRatio
    let width = widthFittingFont > logoView.minimumWidth ? widthFittingFont : logoView.minimumWidth
    let size = CGSize(width: width, height: width * logoRatio)

    logoView.frame = CGRect(origin: .zero, size: size)

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
      attachment.image = logoView.image

      let centerY = fontHeight / 2
      let yPos = centerY - (logoView.frame.height / 2) + (font.descender * logoType.descenderMultiplier)

      attachment.bounds = CGRect(origin: .init(x: 0, y: yPos), size: logoView.bounds.size)
      attachment.isAccessibilityElement = true
      attachment.accessibilityLabel = logoView.accessibilityLabel
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

    let linkConfig = moreInfoOptions.modalLinkStyle.styleConfig
    let linkStyleAttributes = textAttributes.merging(linkConfig.attributes) { $1 }
    let linkAttributes = linkStyleAttributes.merging([.link: infoLink]) { $1 }

    let link: NSMutableAttributedString? = {
      if linkConfig.customContent != nil {
        return linkConfig.customContent! as? NSMutableAttributedString
      } else if linkConfig.text != nil {
        return .init(string: linkConfig.text!)
      } else if let image = linkConfig.image, let renderMode = linkConfig.imageRenderingMode {
        let attachment = NSTextAttachment()
        let imageRatio = image.size.width / image.size.height
        let attachmentHeight = fontHeight * 0.8

        attachment.image = image.withRenderingMode(renderMode)
        attachment.bounds = CGRect(
          origin: .init(x: 0, y: font.descender * 0.6),
          size: CGSize(width: attachmentHeight * imageRatio, height: attachmentHeight)
        )
        return .init(attachment: attachment)
      }

      return nil
    }()

    if link != nil {
      link?.addAttributes(linkAttributes, range: NSRange(location: 0, length: link!.length))
    }

    let strings = (link != nil) ? badgeAndBreakdown + [space, link!] : badgeAndBreakdown

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
