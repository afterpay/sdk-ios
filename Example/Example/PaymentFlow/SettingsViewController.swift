//
//  SettingsViewController.swift
//  Example
//
//  Created by Adam Campbell on 22/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class SettingsViewController: UITableViewController {

  private let textEntryCellIdentifier = String(describing: TextEntryCell.self)

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Settings"

    let closeItem = UIBarButtonItem(
      title: "Close",
      style: .plain,
      target: self,
      action: #selector(didTapClose)
    )

    navigationItem.rightBarButtonItem = closeItem

    tableView.register(TextEntryCell.self, forCellReuseIdentifier: textEntryCellIdentifier)
    tableView.allowsSelection = false
  }

  // MARK: UITableViewDataSource

  private enum Settings: Int, CaseIterable {
    case email
    case host
    case port

    var title: String {
      String(describing: self).capitalized
    }

    var placeholder: String {
      switch self {
      case .email: return "email@example.com"
      case .host: return "localhost"
      case .port: return "3000"
      }
    }
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    Settings.allCases.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let textEntryCell = tableView.dequeueReusableCell(
      withIdentifier: textEntryCellIdentifier,
      for: indexPath
    ) as! TextEntryCell

    let setting = Settings(rawValue: indexPath.row)

    textEntryCell.titleLabel.text = setting?.title
    textEntryCell.textField.placeholder = setting?.placeholder

    return textEntryCell
  }

  // MARK: Actions

  @objc private func didTapClose() {
    dismiss(animated: true, completion: nil)
  }

}

final class TextEntryCell: UITableViewCell {

  let titleLabel = UILabel()
  let textField = UITextField()

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

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
