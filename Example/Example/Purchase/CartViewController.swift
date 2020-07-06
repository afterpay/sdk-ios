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
  private let productCellIdentifier = String(describing: ProductCell.self)
  private let titleSubtitleCellIdentifier = String(describing: TitleSubtitleCell.self)

  init(cart: CartDisplay) {
    self.cart = cart

    super.init(nibName: nil, bundle: nil)

    self.title = "Cart"
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
    tableView.tableFooterView = UIView()
    tableView.delaysContentTouches = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(ProductCell.self, forCellReuseIdentifier: productCellIdentifier)
    tableView.register(TitleSubtitleCell.self, forCellReuseIdentifier: titleSubtitleCellIdentifier)

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

  private enum Section: Int, CaseIterable {
    case products, total

    static func from(section: Int) -> Section {
      Section(rawValue: section)!
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    Section.allCases.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch Section.from(section: section) {
    case .products:
      return cart.products.count
    case .total:
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell

    switch Section.from(section: indexPath.section) {
    case .products:
      let productCell = tableView.dequeueReusableCell(
        withIdentifier: productCellIdentifier,
        for: indexPath) as! ProductCell
      productCell.configure(with: cart.products[indexPath.row])
      cell = productCell

    case .total:
      let titleSubtitleCell = tableView.dequeueReusableCell(
        withIdentifier: titleSubtitleCellIdentifier,
        for: indexPath) as! TitleSubtitleCell
      titleSubtitleCell.configure(title: "Total", subtitle: cart.displayTotal)
      cell = titleSubtitleCell
    }

    return cell
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
