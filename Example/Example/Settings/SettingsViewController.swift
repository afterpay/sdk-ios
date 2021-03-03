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

  private let textCellIdentifier = String(describing: TextSettingCell.self)
  private let segmentedCellIdentifier = String(describing: SegmentedSettingCell.self)
  private let genericCellIdentifier = String(describing: UITableViewCell.self)
  private let controlCellIdentifier = String(describing: ControlCell.self)
  private let settings: [AppSetting]

  init(settings: [AppSetting]) {
    self.settings = settings

    super.init(style: .plain)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Settings"

    tableView.register(TextSettingCell.self, forCellReuseIdentifier: textCellIdentifier)
    tableView.register(SegmentedSettingCell.self, forCellReuseIdentifier: segmentedCellIdentifier)
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: genericCellIdentifier)
    tableView.register(ControlCell.self, forCellReuseIdentifier: controlCellIdentifier)
    tableView.allowsSelection = false
  }

  // MARK: UITableViewDataSource

  enum Section: Int, CaseIterable {
    case message, settings, controls

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

    case .controls:
      return 1
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
      switch settings[indexPath.row] {
      case .text(let setting):
        let settingCell = tableView.dequeueReusableCell(
          withIdentifier: textCellIdentifier,
          for: indexPath
        ) as! TextSettingCell
        settingCell.configure(with: setting)
        cell = settingCell

      case .picker(let setting):
        let settingCell = tableView.dequeueReusableCell(
          withIdentifier: segmentedCellIdentifier,
          for: indexPath
        ) as! SegmentedSettingCell
        settingCell.configure(with: setting)
        cell = settingCell
      }

    case .controls:
      let controlCell = tableView.dequeueReusableCell(
        withIdentifier: controlCellIdentifier,
        for: indexPath
      ) as! ControlCell
      controlCell.configure(
        with: { Repository.shared.fetchConfiguration(forceRefresh: true) },
        title: "Refresh config"
      )
      cell = controlCell
    }

    return cell
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
