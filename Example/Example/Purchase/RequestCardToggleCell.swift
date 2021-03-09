//
//  RequestCardToggleCell.swift
//  Example
//
//  Created by Nabila Herzegovina on 25/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

final class RequestCardToggleCell: UITableViewCell {

  private let titleLabel = UILabel()
  let toggleSwitch = UISwitch()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    titleLabel.text = "Use consumer card?"
    titleLabel.font = .preferredFont(forTextStyle: .headline)

    let horizontalStackView = UIStackView(
      arrangedSubviews: [
        titleLabel,
        toggleSwitch,
      ]
    )
    horizontalStackView.axis = .horizontal
    horizontalStackView.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(horizontalStackView)

    let layoutGuide = contentView.readableContentGuide

    NSLayoutConstraint.activate([
      horizontalStackView.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      horizontalStackView.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      horizontalStackView.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
      horizontalStackView.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
