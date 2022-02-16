//
//  LayeredImageView.swift
//  Afterpay
//
//  Created by Scott Antonac on 16/2/22.
//  Copyright © 2022 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public class LayeredImageView: UIView {
  public var colorScheme: ColorScheme = .static(.blackOnMint) {
    didSet { updateColors(withTraits: traitCollection) }
  }

  internal var backgroundImageView: UIImageView = UIImageView(frame: .zero)
  internal var foregroundImageView: UIImageView = UIImageView(frame: .zero)

  public init(colorScheme: ColorScheme = .static(.blackOnMint)) {
    self.colorScheme = colorScheme

    super.init(frame: .zero)

    sharedInit()
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)

    sharedInit()
  }

  internal func sharedInit() {
    let backgroundImage = UIImage(named: "badge-background", in: Afterpay.bundle, compatibleWith: nil)
    backgroundImageView.image = backgroundImage

    let foregroundImage = UIImage(named: "badge-foreground-afterpay", in: Afterpay.bundle, compatibleWith: nil)
    foregroundImageView.image = foregroundImage

    addSubview(backgroundImageView)
    addSubview(foregroundImageView)

    updateColors(withTraits: traitCollection)

    let ratio = backgroundImage!.size.height / backgroundImage!.size.width

    backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
    foregroundImageView.translatesAutoresizingMaskIntoConstraints = false

    setConstraints(imageView: backgroundImageView)
    setConstraints(imageView: foregroundImageView)

    NSLayoutConstraint.activate([
      heightAnchor.constraint(equalTo: widthAnchor, multiplier: ratio),
      widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor),
    ])
  }

  override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    updateColors(withTraits: traitCollection)
  }

  internal func setConstraints(imageView: UIImageView) {
    imageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
    imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
    imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
    imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
  }

  internal func updateColors(withTraits traitCollection: UITraitCollection) {
    switch traitCollection.userInterfaceStyle {
    case .dark:
      backgroundImageView.tintColor = colorScheme.darkPalette.uiColors.background
      foregroundImageView.tintColor = colorScheme.darkPalette.uiColors.foreground
    case .light, .unspecified:
      fallthrough
    @unknown default:
      backgroundImageView.tintColor = colorScheme.lightPalette.uiColors.background
      foregroundImageView.tintColor = colorScheme.lightPalette.uiColors.foreground
    }
  }
}
