//
//  TitleSubtitleCell.swift
//  Example
//
//  Created by Adam Campbell on 2/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class TitleSubtitleCell: UITableViewCell {

  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    titleLabel.font = .preferredFont(forTextStyle: .headline)
    subtitleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    let stack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.spacing = 8

    contentView.addSubview(stack)

    let layoutGuide = contentView.readableContentGuide

    NSLayoutConstraint.activate([
      stack.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      stack.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      stack.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
      stack.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
    ])
  }

  func configure(title: String, subtitle: String) {
    titleLabel.text = title
    subtitleLabel.text = subtitle
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
