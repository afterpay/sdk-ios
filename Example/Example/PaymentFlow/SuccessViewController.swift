//
//  SuccessViewController.swift
//  Example
//
//  Created by Adam Campbell on 18/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class SuccessViewController: UIViewController {

  private var label: UILabel { view as! UILabel }

  private let token: String

  init(token: String) {
    self.token = token

    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    view = UILabel()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    label.text = "Succeeded with token: \(token)"
    label.numberOfLines = 0
    label.textAlignment = .center
    label.backgroundColor = .systemBackground
    label.textColor = .label
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
