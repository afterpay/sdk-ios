//
//  Label.swift
//  Example
//
//  Created by Adam Campbell on 12/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

extension UILabel {

  static var bodyLabel: UILabel {
    let label = UILabel()
    label.textColor = .appLabel
    label.adjustsFontForContentSizeCategory = true
    label.font = .preferredFont(forTextStyle: .body)
    return label
  }

}
