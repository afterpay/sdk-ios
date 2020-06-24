//
//  SuccessViewController.swift
//  Example
//
//  Created by Adam Campbell on 18/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class MessageViewController: UIViewController {

  private var label: UILabel { view as! UILabel }

  private let message: String

  init(message: String) {
    self.message = message

    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    view = UILabel()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    label.text = message
    label.font = .preferredFont(forTextStyle: .body)
    label.adjustsFontForContentSizeCategory = true
    label.numberOfLines = 0
    label.textAlignment = .center

    if #available(iOS 13.0, *) {
      label.backgroundColor = .systemBackground
      label.textColor = .label
    } else {
      label.backgroundColor = .white
      label.textColor = .black
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
