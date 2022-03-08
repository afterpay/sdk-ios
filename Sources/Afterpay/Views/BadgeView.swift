//
//  BadgeView.swift
//  Afterpay
//
//  Created by Adam Campbell on 31/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public class BadgeView: UIView {
  public var colorScheme: ColorScheme = .static(.blackOnMint) {
    didSet { updateImage(withTraits: traitCollection) }
  }

  internal var image: UIImage?
  private var imageView = UIImageView(frame: .zero)

  internal var minimumWidth: CGFloat = 64

  public var ratio: CGFloat?

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
    updateImage(withTraits: traitCollection)

    let selector = #selector(configurationDidChange)
    let name: NSNotification.Name = .configurationUpdated
    notificationCenter.addObserver(self, selector: selector, name: name, object: nil)
  }

  override public func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    updateImage(withTraits: traitCollection)
  }

  internal func updateImage(withTraits traitCollection: UITraitCollection) {
    let brand = getLocale() == Locales.greatBritain ? "clearpay" : "afterpay"

    var colors = colorScheme.lightPalette.slug
    if traitCollection.userInterfaceStyle == .dark {
      colors = colorScheme.darkPalette.slug
    }

    let imageName = "badge-\(brand)-\(colors)"

    deactivateConstraints()
    image = UIImage(named: imageName, in: Afterpay.bundle, compatibleWith: nil)

    ratio = image!.size.height / image!.size.width

    imageView.image = image
    imageView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(imageView)

    setImageViewConstraints()
    setupConstraints()
  }

  internal func setImageViewConstraints() {
    NSLayoutConstraint.activate([
      imageView.widthAnchor.constraint(equalTo: widthAnchor),
      imageView.heightAnchor.constraint(equalTo: heightAnchor),
    ])
  }

  private var aspectRatioConstraint: NSLayoutConstraint!
  private var minimumWidthConstraint: NSLayoutConstraint!

  private func setupConstraints() {
    aspectRatioConstraint = heightAnchor.constraint(equalTo: widthAnchor, multiplier: ratio!)
    minimumWidthConstraint = widthAnchor.constraint(greaterThanOrEqualTo: widthAnchor)

    NSLayoutConstraint.activate([ aspectRatioConstraint, minimumWidthConstraint ])
  }

  private func deactivateConstraints() {
    if aspectRatioConstraint != nil {
      aspectRatioConstraint.isActive = false
    }

    if minimumWidthConstraint != nil {
      minimumWidthConstraint.isActive = false
    }
  }

  @objc private func configurationDidChange(_ notification: NSNotification) {
    DispatchQueue.main.async {
      self.updateImage(withTraits: self.traitCollection)
    }
  }
}
