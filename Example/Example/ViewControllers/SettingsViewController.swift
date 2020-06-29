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
  private let settings: [Setting]

  init(settings: [Setting]) {
    self.settings = settings

    super.init(style: .plain)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Settings"

    tableView.register(SettingCell.self, forCellReuseIdentifier: cellIdentifier)
    tableView.allowsSelection = false
  }

  // MARK: UITableViewDataSource

  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    settings.count
  }

  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let settingCell = tableView.dequeueReusableCell(
      withIdentifier: cellIdentifier,
      for: indexPath
    ) as! SettingCell

    settingCell.configure(with: settings[indexPath.row])

    return settingCell
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
