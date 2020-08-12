//
//  TextField.swift
//  Example
//
//  Created by Adam Campbell on 12/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

extension UITextField {

  static var roundedTextField: UITextField {
    let textField = UITextField()
    textField.font = .preferredFont(forTextStyle: .body)
    textField.adjustsFontForContentSizeCategory = true
    textField.borderStyle = .roundedRect
    textField.textColor = .appLabel
    return textField
  }

}
