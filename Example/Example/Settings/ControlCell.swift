//
//  ControlCell.swift
//  Example
//
//  Created by Huw Rowlands on 2/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import UIKit

final class ControlCell: UITableViewCell {

  private var buttonAction: (() -> Void)?

  private let button = UIButton(type: .system)

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)

    contentView.addSubview(button)

    let layoutGuide = contentView.readableContentGuide

    let buttonConstraints = [
      button.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      button.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      button.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
      button.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
    ]

    NSLayoutConstraint.activate(buttonConstraints)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func configure(with action: @escaping () -> Void, title: String) {
    buttonAction = action
    button.setTitle(title, for: .normal)
  }

  @objc private func buttonTap() {
    buttonAction?()
  }

}
