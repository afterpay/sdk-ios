//
//  TextSettingCell.swift
//  Example
//
//  Created by Adam Campbell on 23/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class TextSettingCell: UITableViewCell, UITextFieldDelegate {

  private var setting: Setting<String>?

  private let titleLabel = UILabel()
  private let textField = UITextField()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    titleLabel.font = .preferredFont(forTextStyle: .body)
    titleLabel.adjustsFontForContentSizeCategory = true
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

    textField.font = .preferredFont(forTextStyle: .body)
    textField.adjustsFontForContentSizeCategory = true
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.returnKeyType = .done
    textField.autocapitalizationType = .none
    textField.autocorrectionType = .no
    textField.delegate = self

    contentView.addSubview(titleLabel)
    contentView.addSubview(textField)

    let layoutGuide = contentView.readableContentGuide

    let titleConstraints = [
      titleLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      titleLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
    ]

    let textFieldConstraints = [
      textField.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
      textField.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      textField.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
      textField.leadingAnchor.constraint(
        greaterThanOrEqualTo: titleLabel.trailingAnchor,
        constant: 8
      ),
      textField.leadingAnchor.constraint(
        equalTo: layoutGuide.leadingAnchor,
        constant: 64,
        priority: .defaultHigh
      ),
    ]

    NSLayoutConstraint.activate(titleConstraints + textFieldConstraints)
  }

  func configure(with setting: Setting<String>) {
    titleLabel.text = setting.title
    textField.placeholder = setting.defaultValue
    textField.text = setting.wrappedValue == setting.defaultValue ? nil : setting.wrappedValue

    self.setting = setting
  }

  // MARK: UITextFieldDelegate

  func textFieldDidEndEditing(_ textField: UITextField) {
    if let text = textField.text {
      setting?.wrappedValue = text
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
