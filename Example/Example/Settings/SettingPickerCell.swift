//
//  SettingPickerCell.swift
//  Example
//
//  Created by Ryan Davis on 9/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class SettingPickerCell: UITableViewCell, UITextFieldDelegate {

  private var setting: PickerSetting?

  private let titleLabel = UILabel()
  private let segmentedControl = UISegmentedControl()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    titleLabel.font = .preferredFont(forTextStyle: .body)
    titleLabel.adjustsFontForContentSizeCategory = true
    titleLabel.translatesAutoresizingMaskIntoConstraints = false
    titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
    titleLabel.setContentCompressionResistancePriority(.required, for: .horizontal)

    segmentedControl.translatesAutoresizingMaskIntoConstraints = false
    segmentedControl.addTarget(self, action: #selector(segmentedControlUpdated), for: .valueChanged)

    contentView.addSubview(titleLabel)
    contentView.addSubview(segmentedControl)

    let layoutGuide = contentView.readableContentGuide

    let titleConstraints = [
      titleLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      titleLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      titleLabel.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
    ]

    let segmentedControlConstraints = [
      segmentedControl.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
      segmentedControl.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      segmentedControl.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
      segmentedControl.leadingAnchor.constraint(
        greaterThanOrEqualTo: titleLabel.trailingAnchor,
        constant: 8
      ),
    ]

    NSLayoutConstraint.activate(titleConstraints + segmentedControlConstraints)
  }

  func configure(with setting: PickerSetting) {
    titleLabel.text = setting.title
    segmentedControl.removeAllSegments()

    for (index, title) in setting.options.enumerated() {
      segmentedControl.insertSegment(withTitle: title, at: index, animated: false)
    }

    segmentedControl.selectedSegmentIndex = setting.selectedIndex

    self.setting = setting
  }

  @objc private func segmentedControlUpdated() {
    if let title = segmentedControl.titleForSegment(at: segmentedControl.selectedSegmentIndex) {
      setting?.wrappedValue = title
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}

private extension PickerSetting {
  var selectedIndex: Int {
    let selection = wrappedValue
    return options.firstIndex(where: { $0 == selection }) ?? -1
  }
}
