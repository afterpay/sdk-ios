//
//  CashAppReceiptViewController.swift
//  Example
//
//  Created by Scott Antonac on 11/1/2023.
//  Copyright © 2023 Afterpay. All rights reserved.
//

import Foundation
import Afterpay
import PayKit

final class CashAppGrantsViewController: UIViewController {
  private var amount: String
  private var cashTag: String
  private var grants: [CustomerRequest.Grant]

  private lazy var layoutGuide = self.view.safeAreaLayoutGuide

  init(amount: String, cashTag: String, grants: [CustomerRequest.Grant]) {
    self.amount = amount
    self.cashTag = cashTag
    self.grants = grants

    super.init(nibName: nil, bundle: nil)

    self.title = "Cash App Success"
  }

  override func loadView() {
    view = UIView()

    if #available(iOS 13.0, *) {
      view.backgroundColor = .secondarySystemBackground
    } else {
      view.backgroundColor = .white
    }

    showInfo()
  }

  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func showInfo() {
    let amountLabel = UILabel()
    amountLabel.text = "Amount: $\(self.amount)"
    amountLabel.font = .preferredFont(forTextStyle: .title2)
    amountLabel.translatesAutoresizingMaskIntoConstraints = false

    let cashTagLabel = UILabel()
    cashTagLabel.text = "Tag: \(self.cashTag)"
    cashTagLabel.font = .preferredFont(forTextStyle: .title2)
    cashTagLabel.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(cashTagLabel)
    view.addSubview(amountLabel)

    let text = UITextView()
    text.text = """
    Grants associated with the customer request \
    can be used with Cash App’s Create Payment API. \
    Pass those Grants to your backend and call the \
    Create Payment API as a server-to-server \
    call to complete your payment.

    = = = = = =

    \(grants)
    """
    text.font = .preferredFont(forTextStyle: .body)
    text.translatesAutoresizingMaskIntoConstraints = false
    text.isEditable = false

    view.addSubview(text)

    let constraints = [
      cashTagLabel.topAnchor.constraint(equalTo: layoutGuide.topAnchor, constant: 16),
      cashTagLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
      cashTagLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
      amountLabel.topAnchor.constraint(equalTo: cashTagLabel.bottomAnchor, constant: 16),
      amountLabel.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
      amountLabel.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
      text.topAnchor.constraint(equalTo: amountLabel.bottomAnchor, constant: 16),
      text.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor, constant: 16),
      text.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor, constant: -16),
      text.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor, constant: -40)
    ]

    NSLayoutConstraint.activate(constraints)
  }
}
