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
  private let plusButton = UIButton(type: .system)
  private let minusButton = UIButton(type: .system)

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    titleLabel.font = .preferredFont(forTextStyle: .headline)
    priceLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)

    let titlePriceStack = UIStackView(
      arrangedSubviews: [titleLabel, priceLabel]
    )

    plusButton.setTitle("+", for: .normal)
    plusButton.addTarget(self, action: #selector(didTapPlus), for: .touchUpInside)

    minusButton.setTitle("-", for: .normal)
    minusButton.addTarget(self, action: #selector(didTapMinus), for: .touchUpInside)

    let quantityStack = UIStackView(
      arrangedSubviews: [UIView(), minusButton, quantityLabel, plusButton]
    )

    let verticalStack = UIStackView(
      arrangedSubviews: [titlePriceStack, subtitleLabel, quantityStack]
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

  var productId = UUID()

  func configure(with product: ProductDisplay, eventHandler: ((Event) -> Void)? = nil) {
    productId = product.id

    titleLabel.text = product.title
    priceLabel.text = product.displayPrice
    subtitleLabel.text = product.subtitle
    quantityLabel.text = product.quantity
    plusButton.isHidden = !product.isEditable
    minusButton.isHidden = !product.isEditable

    if let eventHandler = eventHandler {
      self.eventHandler = eventHandler
    }
  }

  // MARK: Actions

  enum Event {
    case didTapPlus(productId: UUID)
    case didTapMinus(productId: UUID)
  }

  var eventHandler: (Event) -> Void = { _ in }

  @objc private func didTapPlus() {
    eventHandler(.didTapPlus(productId: productId))
  }

  @objc private func didTapMinus() {
    eventHandler(.didTapMinus(productId: productId))
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
