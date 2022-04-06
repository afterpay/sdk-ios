//
//  AfterpayAssetProvider.swift
//  Afterpay
//
//  Created by Scott Antonac on 6/4/2022.
//  Copyright © 2022 Afterpay. All rights reserved.
//

import Foundation

import UIKit

internal class AfterpayAssetProvider {
  internal static func image(named: String) -> UIImage? {
    return UIImage(named: named, in: Bundle.apResource, compatibleWith: nil)
  }

  internal static func color(named: String) -> UIColor? {
    return UIColor(named: named, in: Bundle.apResource, compatibleWith: nil)
  }
}
