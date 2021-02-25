//
//  WelcomeViewIcons.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 23/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

struct OpeningTimeIconSVGConfiguration: SVGConfiguration {
  var colorScheme: ColorScheme

  func svg(localizedFor locale: Locale, withTraits traitCollection: UITraitCollection) -> SVG {
    return .openingTimeIcon
  }

  func accessibilityLabel(localizedFor locale: Locale) -> String {
    return "Calendar Icon"
  }
}

struct ThumbsUpIconSVGConfiguration: SVGConfiguration {
  var colorScheme: ColorScheme

  func svg(localizedFor locale: Locale, withTraits traitCollection: UITraitCollection) -> SVG {
    return .thumbsUpIcon
  }

  func accessibilityLabel(localizedFor locale: Locale) -> String {
    return "Thumbs up Icon"
  }
}

struct DiamondIconSVGConfiguration: SVGConfiguration {
  var colorScheme: ColorScheme

  func svg(localizedFor locale: Locale, withTraits traitCollection: UITraitCollection) -> SVG {
    return .diamondIcon
  }

  func accessibilityLabel(localizedFor locale: Locale) -> String {
    return "Diamond Icon"
  }
}

struct ClockIconSVGConfiguration: SVGConfiguration {
  var colorScheme: ColorScheme

  func svg(localizedFor locale: Locale, withTraits traitCollection: UITraitCollection) -> SVG {
    return .clockIcon
  }

  func accessibilityLabel(localizedFor locale: Locale) -> String {
    return "Clock Icon"
  }
}
