//
//  CartViewController.swift
//  Example
//
//  Created by Adam Campbell on 2/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Foundation

final class CartViewController: UIViewController, UITableViewDataSource {

  private var tableView: UITableView!
  private let cart: CartDisplay
  private let genericCellIdentifier = String(describing: UITableViewCell.self)
  private let productCellIdentifier = String(describing: ProductCell.self)
  private let checkoutOptionsCellIdentifier = String(describing: CheckoutOptionsCell.self)
  private let titleSubtitleCellIdentifier = String(describing: TitleSubtitleCell.self)
  private let eventHandler: (Event) -> Void

  enum Event {
    case didTapPay
    case optionsChanged(CheckoutOptionsCell.Event)
  }

  init(cart: CartDisplay, eventHandler: @escaping (Event) -> Void) {
    self.cart = cart
    self.eventHandler = eventHandler

    super.init(nibName: nil, bundle: nil)

    self.title = "Cart"
  }

  override func loadView() {
    view = UIView()
    view.backgroundColor = .appBackground

    tableView = UITableView()
    tableView.dataSource = self
    tableView.allowsSelection = false
    tableView.tableFooterView = UIView()
    tableView.delaysContentTouches = false
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: genericCellIdentifier)
    tableView.register(ProductCell.self, forCellReuseIdentifier: productCellIdentifier)
    tableView.register(CheckoutOptionsCell.self, forCellReuseIdentifier: checkoutOptionsCellIdentifier)
    tableView.register(TitleSubtitleCell.self, forCellReuseIdentifier: titleSubtitleCellIdentifier)

    let payButton: UIButton = PaymentButton()
    payButton.isEnabled = cart.payEnabled
    payButton.accessibilityIdentifier = "payNow"
    payButton.addTarget(self, action: #selector(didTapPay), for: .touchUpInside)

    view.addSubview(tableView)
    view.addSubview(payButton)

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: payButton.topAnchor),
      payButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      payButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      payButton.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor, constant: -16),
    ])
  }

  // MARK: Actions

  @objc private func didTapPay() {
    eventHandler(.didTapPay)
  }

  // MARK: UITableViewDataSource

  private enum Section: Int, CaseIterable {
    case message, products, total, options

    static func from(section: Int) -> Section {
      Section.allCases[section]
    }
  }

  func numberOfSections(in tableView: UITableView) -> Int {
    Section.allCases.count
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    switch Section.from(section: section) {
    case .message:
      return cart.message == nil ? 0 : 1
    case .products:
      return cart.products.count
    case .total:
      return 1
    case .options:
      return 1
    }
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell

    switch Section.from(section: indexPath.section) {
    case .message:
      cell = tableView.dequeueReusableCell(
        withIdentifier: genericCellIdentifier,
        for: indexPath)
      cell.textLabel?.text = cart.message

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

    case .options:
      let optionsCell = tableView.dequeueReusableCell(
        withIdentifier: checkoutOptionsCellIdentifier,
        for: indexPath) as! CheckoutOptionsCell

      optionsCell.configure(
        options: cart.checkoutV2Options,
        expressCheckout: cart.expressCheckout
      ) { option in
        self.eventHandler(.optionsChanged(option))
      }

      cell = optionsCell
    }

    return cell
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
