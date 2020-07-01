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

}
