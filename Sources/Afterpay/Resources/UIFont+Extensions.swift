//
//  UIFont+Extensions.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 25/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
  // MARK: - Afterpay Custom Font
  private static let afterPayFontTypeface = "ItalianPlateNo2Expanded"

  enum AfterpayFontWeight: String {
    case bold = "-Bold"
    case medium = "-Medium"
    case semiBold = "-Demibold"
    case regular = "-Regular"
  }

  static func afterPayFont(weight: AfterpayFontWeight, size: CGFloat) -> UIFont {
    let fontName = "\(afterPayFontTypeface)\(weight.rawValue)"

    if UIFont.fontNames(forFamilyName: afterPayFontTypeface).contains(fontName) == false {
      registerFont(fileName: fontName)
    }

    guard let font = UIFont(name: fontName, size: size) else {
      let fontWeight: UIFont.Weight
      
      switch weight {
      case .bold:
        fontWeight = .bold
      case .semiBold:
        fontWeight = .semibold
      case .regular:
        fontWeight = .regular
      case .medium:
        fontWeight = .medium
      }

      return UIFont.systemFont(ofSize: size, weight: fontWeight)
    }
    return font
  }

  // MARK: - Register Font
  static func registerFont(fileName: String) {

    let bundle = AfterpayBundleLocator.resourceBundle

    guard let resourcePathString = bundle.path(forResource: fileName, ofType: ".otf") else {
      print("Path for resource not found: \(fileName).otf")
      return
    }

    guard let fontData = NSData(contentsOfFile: resourcePathString) else {
      print("Unable to load font data: \(fileName)")
      return
    }

    guard let dataProvider = CGDataProvider(data: fontData) else {
      print("Unable to load data profider for font: \(fileName)")
      return
    }

    guard let font = CGFont(dataProvider) else {
      print("Unable to load font: \(fileName)")
      return
    }

    if CTFontManagerRegisterGraphicsFont(font, nil) == false {
      print("Failed to register graphics font: \(fileName)")
      return
    }
  }
}
