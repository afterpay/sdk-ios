//
//  EnterAmountViewController.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 22/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class EnterAmountViewController: UIViewController {

  enum Screen: Equatable {
    case enterAmount
    case welcome
  }

  private let enterAmountView: EnterAmountView
  private let welcomeView: WelcomeView
  private var enterAmountAction: (() -> Void)?

  private var currentScreen: Screen = .welcome {
    didSet {
      reloadView()
    }
  }

  init(aggregatorName: String, merchantName: String) {
    self.welcomeView = WelcomeView(continueAction: #selector(welcomeButtonTapped), aggregatorName: aggregatorName)
    self.enterAmountView = EnterAmountView(continueAction: #selector(enterAmountButtonTapped), merchantName: merchantName)

    super.init(nibName: nil, bundle: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    navigationItem.titleView = LogoView()

    welcomeView.backgroundColor = .white
    enterAmountView.backgroundColor = .white

    welcomeView.translatesAutoresizingMaskIntoConstraints = false
    enterAmountView.translatesAutoresizingMaskIntoConstraints = false

    view.addSubview(welcomeView)
    view.addSubview(enterAmountView)

    reloadView()
  }

  override func viewWillAppear(_ animated: Bool) {
    if currentScreen == .enterAmount {
      enterAmountView.amountField.becomeFirstResponder()
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    view.endEditing(true)
  }

  private func reloadView() {
    let subview: UIView
    switch currentScreen {
    case .enterAmount:
      enterAmountView.amountField.becomeFirstResponder()
      subview = enterAmountView
    case .welcome:
      subview = welcomeView
      view.endEditing(true)
    }

    view.bringSubviewToFront(subview)
    updateLayout(with: subview)
  }

  private func updateLayout(with subview: UIView) {
    NSLayoutConstraint.activate([
      subview.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
      subview.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
      subview.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      subview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  @objc private func welcomeButtonTapped() {
    currentScreen = .enterAmount
  }

  @objc private func enterAmountButtonTapped() {
    enterAmountAction?()
    navigationController?.popViewController(animated: true)
  }

  func configureEnterAmountAction(_ action: @escaping () -> Void) {
    enterAmountAction = action
  }

  func setAmount(value: String) {
    enterAmountView.amountField.text = value
  }

  func getAmountValue() -> String? {
    return enterAmountView.amountField.text
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
