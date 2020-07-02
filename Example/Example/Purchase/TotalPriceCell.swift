//
//  TotalPriceCell.swift
//  Example
//
//  Created by Adam Campbell on 2/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class TotalPriceCell: UITableViewCell {

  private let totalPriceLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    let totalDescriptionLabel = UILabel()
    totalDescriptionLabel.text = "Total"
    totalDescriptionLabel.font = .preferredFont(forTextStyle: .headline)

    totalPriceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    let stack = UIStackView(arrangedSubviews: [totalDescriptionLabel, totalPriceLabel])
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

  func configure(with totalPrice: String) {
    totalPriceLabel.text = totalPrice
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
