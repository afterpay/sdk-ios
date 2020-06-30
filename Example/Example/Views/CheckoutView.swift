//
//  CheckoutView.swift
//  Example
//
//  Created by Adam Campbell on 24/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class CheckoutView: UITableView, UITableViewDataSource {

  private let cellIdentifier = String(describing: ProductCell.self)

  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: frame, style: style)

    register(ProductCell.self, forCellReuseIdentifier: cellIdentifier)
    dataSource = self
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private var products: [Product] = []

  func configure(with products: [Product]) {
    self.products = products

    reloadData()
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return products.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = dequeueReusableCell(withIdentifier: cellIdentifier) as! ProductCell
    let product = products[indexPath.row]
    cell.configure(with: product)
    return cell
  }

  private final class ProductCell: UITableViewCell {

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

}
