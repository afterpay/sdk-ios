//
//  CartViewController.swift
//  Example
//
//  Created by Adam Campbell on 2/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Foundation
import PayKitUI

final class CartViewController: UIViewController, UITableViewDataSource {
  private var tableView: UITableView!
  private let cart: CartDisplay
  private let genericCellIdentifier = String(describing: UITableViewCell.self)
  private let productCellIdentifier = String(describing: ProductCell.self)
  private let checkoutOptionsCellIdentifier = String(describing: CheckoutOptionsCell.self)
  private let titleSubtitleCellIdentifier = String(describing: TitleSubtitleCell.self)
  private let eventHandler: (Event) -> Void

  private lazy var cashButton = CashAppPayButton(size: .large) { [weak self] in
    self?.didTapCashAppPay()
  }

  private lazy var cashAppButtonForV3 = CashAppPayButton(size: .large) { [weak self] in
    self?.eventHandler(.didTapSingleUseCardButtonWithCashAppPay)
  }

  private var checkoutOption: CheckoutPickerOption = .v1 {
    didSet { updateViewState() }
  }

  enum Event {
    case didTapPay
    case didTapCashAppPay
    case cartDidLoad(CashAppPayButton)
    case optionsChanged(CheckoutOptionsCell.Event)
    case didTapSingleUseCardButton
    case didTapSingleUseCardButtonWithCashAppPay
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

    view.addSubview(tableView)

    var tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)

    if Afterpay.enabled {
      let payButton: UIButton = PaymentButton(
        colorScheme: .dynamic(lightPalette: .blackOnMint, darkPalette: .mintOnBlack),
        buttonKind: .checkout
      )
      payButton.isEnabled = cart.payEnabled
      payButton.accessibilityIdentifier = "payNow"
      payButton.addTarget(self, action: #selector(didTapPay), for: .touchUpInside)

      cashButton.accessibilityIdentifier = "payWithCashApp"
      cashAppButtonForV3.accessibilityIdentifier = "payWithV3UsingCashApp"

      let stack = UIStackView(arrangedSubviews: [payButton, cashButton, cashAppButtonForV3])
      stack.axis = .vertical
      stack.isLayoutMarginsRelativeArrangement = true
      stack.directionalLayoutMargins = .init(top: 16, leading: 16, bottom: 8, trailing: 16)
      stack.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(stack)

      NSLayoutConstraint.activate([
        stack.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        stack.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        stack.bottomAnchor.constraint(equalTo: view.readableContentGuide.bottomAnchor),
      ])

      tableViewBottomAnchor = tableView.bottomAnchor.constraint(equalTo: payButton.topAnchor)
    }

    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableViewBottomAnchor,
    ])

    let editCheckoutButton = UIBarButtonItem(
      title: "Edit",
      style: .plain,
      target: self,
      action: #selector(presentPickerController)
    )
    navigationItem.setRightBarButton(editCheckoutButton, animated: false)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    eventHandler(.cartDidLoad(self.cashButton))

    updateViewState()
  }

  func updateViewState() {
    cashButton.isHidden = (checkoutOption == .v1 || checkoutOption == .v3)
    cashAppButtonForV3.isHidden = (checkoutOption == .v1 || checkoutOption == .v2)
    eventHandler(.optionsChanged(.expressEnabled(checkoutOption == .v2)))
  }

  // MARK: Actions

  @objc private func didTapPay() {
    switch checkoutOption {
    case .v1, .v2:
      eventHandler(.didTapPay)
    case .v3:
      eventHandler(.didTapSingleUseCardButton)
    }
  }

  @objc private func didTapCashAppPay() {
    eventHandler(.didTapCashAppPay)
  }

  @objc private func presentPickerController() {
    let controller = CheckoutPickerViewController(selectedOption: checkoutOption, delegate: self)
    controller.title = "Configuration"
    present(UINavigationController(rootViewController: controller), animated: true)
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
      switch checkoutOption {
      case .v1:
        return 0
      case .v2, .v3:
        return 1
      }
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

      switch checkoutOption {
      case .v1:
        break
      case .v2:
        optionsCell.configure(
          options: cart.checkoutV2Options,
          expressCheckout: cart.expressCheckout
        ) { [weak self] option in
          self?.eventHandler(.optionsChanged(option))
        }
      case .v3:
        optionsCell.configureForV3(
          buyNow: cart.checkoutV2Options.buyNow
        ) { [weak self] option in
          self?.eventHandler(.optionsChanged(option))
        }
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

// MARK: - CheckoutPickerControllerDelegate

extension CartViewController: CheckoutPickerControllerDelegate {
  func didSelectCancel(_ controller: CheckoutPickerViewController) {
    controller.dismiss(animated: true)
  }

  func didSelectCheckoutOption(_ controller: CheckoutPickerViewController, option: CheckoutPickerOption) {
    checkoutOption = option
    tableView.reloadData()
    controller.dismiss(animated: true)
  }
}
