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
  public var colorScheme: ColorScheme = .static(.default) {
    didSet { updateColors(withTraits: traitCollection) }
  }

  public var ratio: CGFloat?

  internal var backgroundImageView: UIImageView = UIImageView(frame: .zero)
  internal var foregroundImageView: UIImageView = UIImageView(frame: .zero)
  internal var imageLayers: (background: String?, foreground: String?) = (background: nil, foreground: nil) {
    didSet { updateImages() }
  }
  internal var polyChromeImageLayer: String?
  internal var currentPalette: ColorPalette?
  private var isMigratedRegion = false
  public init(colorScheme: ColorScheme = .static(.default)) {
    self.colorScheme = colorScheme
    isMigratedRegion = Afterpay.isCashAppAfterpayRegion
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

  @objc private func configurationDidChange(_ notification: NSNotification) {
    DispatchQueue.main.async {
      self.updateImages()
    }
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
      currentPalette = colorScheme.darkPalette
    case .light, .unspecified:
      fallthrough
    @unknown default:
      currentPalette = colorScheme.lightPalette
    }
    if let currentPalette {
      let color = resolveColorScheme(palette: currentPalette)
      backgroundImageView.tintColor = color.background
      foregroundImageView.tintColor = color.foreground
    }
  }

  private func resolveColorScheme(palette: ColorPalette) -> (foreground: UIColor?, background: UIColor?) {
    if isMigratedRegion {
      return palette.uiColorsCashAppAfterpay
    }
    return palette.uiColors
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

  private func resolveForegroundImage() -> UIImage? {
    /// requiresPolychrome checks if we're using a color palette that requires using the polychrome asset
    /// which right now is only the default color scheme.  isMigratedRegion checks if the region has migrated
    /// to the CashAppAfterpay convergence branding.  If both are true, then we should use the new CashAppAfterpay
    /// polychrome asset. Otherwise use the legacy Afterpay/Clearpay branding
    if let currentPalette,
      let polyChromeImageLayer,
      currentPalette.requiresPolychrome &&
      isMigratedRegion {
        return AfterpayAssetProvider.image(named: polyChromeImageLayer)
    } else if let foreground = imageLayers.foreground {
      return AfterpayAssetProvider.image(named: foreground)
    }
    return nil
  }

  private func drawBackgroundBorder() {
    guard let currentPalette, isMigratedRegion && currentPalette == .lightMono else { return }
    backgroundImageView.layer.borderWidth = 1
    backgroundImageView.layer.borderColor = UIColor.black.cgColor
    backgroundImageView.layer.cornerRadius = 10
  }

  internal func updateImages() {
    self.isHidden = !Afterpay.enabled

    if let background = imageLayers.background {
      deactivateConstraints()

      let backgroundImage = AfterpayAssetProvider.image(named: background)
      let foregroundImage = resolveForegroundImage()
      drawBackgroundBorder()
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
