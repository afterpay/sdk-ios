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
  internal var layers: (background: String?, foreground: String?) = (background: nil, foreground: nil) {
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

    let selector = #selector(configurationDidChange)
    let name: NSNotification.Name = .configurationUpdated
    notificationCenter.addObserver(self, selector: selector, name: name, object: nil)
  }

  override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    updateColors(withTraits: traitCollection)
  }

  internal func setImageViewConstraints(imageView: UIImageView) {
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

  private var aspectRatioConstraint: NSLayoutConstraint!
  private var minimumWidthConstraint: NSLayoutConstraint!

  private func deactivateConstraints() {
    if aspectRatioConstraint != nil {
      aspectRatioConstraint.isActive = true
    }

    if minimumWidthConstraint != nil {
      minimumWidthConstraint.isActive = true
    }
  }

  private func setupConstraints(ratio: CGFloat) {
    if aspectRatioConstraint != nil {
      NSLayoutConstraint.deactivate([ aspectRatioConstraint ])
    }
    aspectRatioConstraint = heightAnchor.constraint(equalTo: widthAnchor, multiplier: ratio)
    minimumWidthConstraint = widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor)

    NSLayoutConstraint.activate([ aspectRatioConstraint, minimumWidthConstraint ])
  }

  internal func updateImages() {
    if let background = layers.background, let foreground = layers.foreground {
      deactivateConstraints()

      let backgroundImage = UIImage(named: background, in: Afterpay.bundle, compatibleWith: nil)
      let foregroundImage = UIImage(named: foreground, in: Afterpay.bundle, compatibleWith: nil)

      let ratio = backgroundImage!.size.height / backgroundImage!.size.width

      backgroundImageView.image = backgroundImage
      foregroundImageView.image = foregroundImage
      backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
      foregroundImageView.translatesAutoresizingMaskIntoConstraints = false

      setImageViewConstraints(imageView: backgroundImageView)
      setImageViewConstraints(imageView: foregroundImageView)

      setupConstraints(ratio: ratio)
    }
  }

  internal func setForeground() {}

  @objc private func configurationDidChange(_ notification: NSNotification) {
    DispatchQueue.main.async {
      self.setForeground()
    }
  }
}
