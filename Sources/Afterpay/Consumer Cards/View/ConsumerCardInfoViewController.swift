//
//  ConsumerCardInfoViewController.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 10/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import UIKit

class ConsumerCardInfoViewController: UIViewController {

  private let titleLabel = TitleLabel(with: "Shop now, pay later with Afterpay on Rakuten", fontSize: 32)

  private let headlineTexts: [String] = [
    "Add Products to your Rakuten Cart",
    "Select Buy now. Pay later with Afterpay",
    "Login or create an Afterpay account",
    "Purchase split into 4 payments,  due every 2 weeks",
  ]

  private let verticalStackView: UIStackView = {
    let stackview = UIStackView()
    stackview.axis = .vertical
    stackview.translatesAutoresizingMaskIntoConstraints = false
    stackview.spacing = 16

    return stackview
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    navigationItem.titleView = LogoView()

    for (index, text) in headlineTexts.enumerated() {
      verticalStackView.addArrangedSubview(createHeadlineView(index: index, text: text))
    }

    view.addSubview(titleLabel)
    view.addSubview(verticalStackView)

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

      verticalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 42),
      verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
    ])
  }

  private func createHeadlineView(index: Int, text: String) -> UIView {
    let superview = UIView()
    let indexLabel = createHeadlineLabel(with: "\(index).")
    let headlineLabel = createHeadlineLabel(with: text)
    let divider = DividerView()

    indexLabel.sizeToFit()

    superview.addSubview(indexLabel)
    superview.addSubview(headlineLabel)
    superview.addSubview(divider)

    NSLayoutConstraint.activate([
      indexLabel.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      indexLabel.topAnchor.constraint(equalTo: superview.topAnchor),
      indexLabel.trailingAnchor.constraint(equalTo: headlineLabel.leadingAnchor, constant: -16),
      indexLabel.lastBaselineAnchor.constraint(equalTo: headlineLabel.lastBaselineAnchor),

      headlineLabel.topAnchor.constraint(equalTo: superview.topAnchor),
      headlineLabel.trailingAnchor.constraint(equalTo: superview.trailingAnchor),

      divider.topAnchor.constraint(equalTo: headlineLabel.bottomAnchor, constant: 16),
      divider.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      divider.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
      divider.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
    ])

    return superview
  }

  private func createHeadlineLabel(with text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textAlignment = .left

    label.numberOfLines = 0

    let font = UIFont.afterPayFont(weight: .bold, size: 14)
    label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: font)

    label.adjustsFontForContentSizeCategory = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }
}
