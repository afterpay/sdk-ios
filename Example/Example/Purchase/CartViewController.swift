//
//  CartViewController.swift
//  Example
//
//  Created by Adam Campbell on 2/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

final class CartViewController: UIViewController, UITableViewDataSource {

  private var tableView: UITableView!
  private let cart: CartDisplay
  private let cellIdentifier = String(describing: ProductCell.self)

  init(cart: CartDisplay) {
    self.cart = cart

    super.init(nibName: nil, bundle: nil)
  }

  override func loadView() {
    view = UIView()

    if #available(iOS 13.0, *) {
      view.backgroundColor = .systemBackground
    } else {
      view.backgroundColor = .white
    }

    tableView = UITableView()
    tableView.dataSource = self
    tableView.allowsSelection = false
    tableView.delaysContentTouches = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(ProductCell.self, forCellReuseIdentifier: cellIdentifier)

    let payButton = UIButton(type: .system)
    payButton.backgroundColor = .systemBlue
    payButton.setTitle("Pay with Afterpay", for: .normal)
    payButton.setTitleColor(.white, for: .normal)
    payButton.translatesAutoresizingMaskIntoConstraints = false
    payButton.titleLabel?.font = .preferredFont(forTextStyle: .title2)
    payButton.addTarget(self, action: #selector(didTapPay), for: .touchUpInside)

    view.addSubview(tableView)
    view.addSubview(payButton)

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: payButton.topAnchor),
      payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      payButton.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),
    ])
  }

  // MARK: Actions

  @objc private func didTapPay() {
  }

  // MARK: UITableViewDataSource

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    cart.products.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! ProductCell
    let product = cart.products[indexPath.row]
    cell.configure(with: product) { _ in }
    return cell
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
