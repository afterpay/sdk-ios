//
//  ProductsViewController.swift
//  Example
//
//  Created by Adam Campbell on 1/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Foundation
import UIKit

final class ProductsViewController: UIViewController, UITableViewDataSource {

  private var tableView: UITableView!
  private var products: [ProductDisplay] = []
  private let cellIdentifier = String(describing: ProductCell.self)
  private let eventHandler: (Event) -> Void

  enum Event {
    case viewCart
    case productEvent(ProductCell.Event)
  }

  init(eventHandler: @escaping (Event) -> Void) {
    self.eventHandler = eventHandler

    super.init(nibName: nil, bundle: nil)

    self.title = "Aftersnack"
  }

  override func loadView() {
    view = UIView()
    view.backgroundColor = .appBackground

    tableView = UITableView()
    tableView.dataSource = self
    tableView.allowsSelection = false
    tableView.delaysContentTouches = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(ProductCell.self, forCellReuseIdentifier: cellIdentifier)

    let cartButton: UIButton = .primaryButton
    cartButton.setTitle("View Cart", for: .normal)
    cartButton.addTarget(self, action: #selector(didTapViewCart), for: .touchUpInside)

    view.addSubview(tableView)
    view.addSubview(cartButton)

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: cartButton.topAnchor),
      cartButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      cartButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      cartButton.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),
    ])

    if AfterpayFeatures.widgetEnabled {
      navigationItem.rightBarButtonItem = UIBarButtonItem(
        title: "Tokenless…",
        style: .plain,
        target: self,
        action: #selector(tokenlessWidgetTapped)
      )
    }
  }

  func update(products: [ProductDisplay]) {
    self.products = products

    if isViewLoaded {
      tableView.reloadData()
    }
  }

  // MARK: Actions

  @objc private func tokenlessWidgetTapped() {
    let widgetViewController = WidgetViewController(title: "Tokenless", amount: "200.00")
    navigationController?.pushViewController(widgetViewController, animated: true)
  }

  @objc private func didTapViewCart() {
    eventHandler(.viewCart)
  }

  // MARK: UITableViewDataSource

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    products.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ProductCell
    let product = products[indexPath.row]
    cell.configure(with: product) { [unowned self] in self.eventHandler(.productEvent($0)) }
    return cell
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
