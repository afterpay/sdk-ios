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

  public var ratio: CGFloat?

  internal var backgroundImageView: UIImageView = UIImageView(frame: .zero)
  internal var foregroundImageView: UIImageView = UIImageView(frame: .zero)
  internal var imageLayers: (background: String?, foreground: String?) = (background: nil, foreground: nil) {
    didSet { updateImages() }
  }

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
    addSubview(backgroundImageView)
    addSubview(foregroundImageView)

    updateColors(withTraits: traitCollection)
  }

  override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    updateColors(withTraits: traitCollection)
  }

  internal func setImageViewConstraints() {
    NSLayoutConstraint.activate([
      backgroundImageView.widthAnchor.constraint(equalTo: widthAnchor),
      backgroundImageView.heightAnchor.constraint(equalTo: heightAnchor),
      foregroundImageView.widthAnchor.constraint(equalTo: widthAnchor),
      foregroundImageView.heightAnchor.constraint(equalTo: heightAnchor),
    ])
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

  private var aspectRatioConstraint: NSLayoutConstraint!
  private var minimumWidthConstraint: NSLayoutConstraint!

  private func deactivateConstraints() {
    if aspectRatioConstraint != nil {
      aspectRatioConstraint.isActive = false
    }

    if minimumWidthConstraint != nil {
      minimumWidthConstraint.isActive = false
    }
  }

  private func setupConstraints() {
    aspectRatioConstraint = heightAnchor.constraint(equalTo: widthAnchor, multiplier: ratio!)
    minimumWidthConstraint = widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor)

    NSLayoutConstraint.activate([ aspectRatioConstraint, minimumWidthConstraint ])
  }

  internal func updateImages() {
    if let background = imageLayers.background, let foreground = imageLayers.foreground {
      deactivateConstraints()

      let backgroundImage = UIImage(named: background, in: Afterpay.bundle, compatibleWith: nil)
      let foregroundImage = UIImage(named: foreground, in: Afterpay.bundle, compatibleWith: nil)

      ratio = backgroundImage!.size.height / backgroundImage!.size.width

      backgroundImageView.image = backgroundImage
      foregroundImageView.image = foregroundImage
      backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
      foregroundImageView.translatesAutoresizingMaskIntoConstraints = false

      setImageViewConstraints()
      setupConstraints()
    }
  }

  internal func setForeground() {}
}
