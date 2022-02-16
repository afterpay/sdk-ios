//
//  BadgeView.swift
//  Afterpay
//
//  Created by Adam Campbell on 31/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public final class BadgeView: LayeredImageView {
  override internal func sharedInit() {
    let backgroundImage = UIImage(named: "badge-background", in: Afterpay.bundle, compatibleWith: nil)
    backgroundImageView.image = backgroundImage

    let foregroundImage = UIImage(named: "badge-foreground-afterpay", in: Afterpay.bundle, compatibleWith: nil)
    foregroundImageView.image = foregroundImage

    super.sharedInit()
  }
}
