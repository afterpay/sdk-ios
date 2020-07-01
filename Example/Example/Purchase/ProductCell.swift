//
//  ProductCell.swift
//  Example
//
//  Created by Adam Campbell on 1/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

final class ProductCell: UITableViewCell {

  private let titleLabel = UILabel()
  private let subtitleLabel = UILabel()
  private let priceLabel = UILabel()
  private let quantityLabel = UILabel()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    titleLabel.font = .preferredFont(forTextStyle: .headline)
    priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    let horizontalStack = UIStackView(
      arrangedSubviews: [titleLabel, priceLabel]
    )

    let verticalStack = UIStackView(
      arrangedSubviews: [horizontalStack, subtitleLabel, quantityLabel]
    )

    verticalStack.axis = .vertical
    verticalStack.spacing = 8
    verticalStack.translatesAutoresizingMaskIntoConstraints = false

    contentView.addSubview(verticalStack)

    let layoutGuide = contentView.readableContentGuide

    NSLayoutConstraint.activate([
      verticalStack.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      verticalStack.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      verticalStack.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
      verticalStack.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
    ])
  }

  func configure(with product: Product) {
    titleLabel.text = product.name
    priceLabel.text = "\(product.price)"
    subtitleLabel.text = product.description
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
