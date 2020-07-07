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

  private let cellIdentifier = String(describing: SettingCell.self)
  private let genericCellIdentifier = String(describing: UITableViewCell.self)
  private let settings: [Setting]

  init(settings: [Setting]) {
    self.settings = settings

    super.init(style: .plain)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Settings"

    tableView.register(SettingCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: genericCellIdentifier)
    tableView.allowsSelection = false
  }

  // MARK: UITableViewDataSource

  enum Section: Int, CaseIterable {
    case message, settings

    static func from(section: Int) -> Section {
      Section(rawValue: section)!
    }
  }

  override func numberOfSections(in tableView: UITableView) -> Int {
    Section.allCases.count
  }

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch Section.from(section: section) {
    case .message:
      return 1

    case .settings:
      return settings.count
    }
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell

    switch Section.from(section: indexPath.section) {
    case .message:
      cell = tableView.dequeueReusableCell(withIdentifier: genericCellIdentifier, for: indexPath)
      cell.textLabel?.text = "Updates to email and currency code require a restart to take effect"
      cell.textLabel?.font = .preferredFont(forTextStyle: .footnote)
      cell.textLabel?.numberOfLines = 0

    case .settings:
      let settingCell = tableView.dequeueReusableCell(
        withIdentifier: cellIdentifier,
        for: indexPath) as! SettingCell
      settingCell.configure(with: settings[indexPath.row])
      cell = settingCell
    }

    return cell
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
