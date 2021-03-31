//
//  VirtualCardDisplayViewController.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 31/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class VirtualCardDisplayViewController: UIViewController {

  private let merchantName: String
  private let singleUseCardView: SingleUseCardView
  private var continueAction: (() -> Void)?
  private var editCancelAction: (() -> Void)?

  init(merchantName: String) {
    self.merchantName = merchantName
    self.singleUseCardView = SingleUseCardView(
      merchantName: merchantName,
      continueAction: #selector(continueButtonTapped),
      editCancelAction: #selector(editCancelButtonTapped)
    )

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.titleView = LogoView()

    view.backgroundColor  = .white

    singleUseCardView.backgroundColor = .white
    singleUseCardView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(singleUseCardView)
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    updateLayout()
  }

  private func updateLayout() {
    NSLayoutConstraint.activate([
      singleUseCardView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      singleUseCardView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      singleUseCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      singleUseCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  func updateCardDetails(with amount: Money, virtualCard: VirtualCard, expiry: String) {
    singleUseCardView.updateCardDetails(with: amount, virtualCard: virtualCard, expiry: expiry)
  }

  func configureButtons(continueAction: @escaping () -> Void, editCancelAction: @escaping () -> Void) {
    self.continueAction = continueAction
    self.editCancelAction = editCancelAction

  }

  @objc func continueButtonTapped() {
    continueAction?()
  }

  @objc func editCancelButtonTapped() {
    editCancelAction?()
  }
}
