//
//  ConsumerCardInfoViewController.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 10/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import UIKit

// swiftlint:disable line_length
class ConsumerCardInfoViewController: UIViewController {

  private let titleLabel = TitleLabel(with: "", fontSize: 32)
  private let termsAndConditionTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "Terms and conditions"
    label.textAlignment = .left

    label.numberOfLines = 1

    let font = UIFont.afterPayFont(weight: .regular, size: 14)
    label.font = UIFontMetrics(forTextStyle: .title3).scaledFont(for: font)
    label.textColor = UIColor.termsConditionTitleColor

    label.adjustsFontForContentSizeCategory = true
    label.translatesAutoresizingMaskIntoConstraints = false

    return label
  }()

  private let termsAndConditionContentView = TermsAndConditionTextView()

  private var headlineTexts: [String] = [
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

  init(merchantName: String, aggregator: String) {
    super.init(nibName: nil, bundle: nil)

    headlineTexts.insert("Add Products to your \(merchantName) Cart", at: 0)
    titleLabel.text = "Shop now, pay later with Afterpay on \(merchantName)"
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .white
    navigationItem.titleView = LogoView()

    for (index, text) in headlineTexts.enumerated() {
      verticalStackView.addArrangedSubview(createHeadlineView(index: index + 1, text: text))
    }

    let lineHeightMultiple: CGFloat = 1.42
    let hyperlinkTitle = "Click here for full terms."
    let year = Calendar.current.component(.year, from: Date())

    termsAndConditionContentView.configure(with: """
    You must be over 18, a resident of the US and meet additional eligibility criteria to qualify. Late fees may apply. Estimated payment amounts shown on product pages exclude taxes and shipping charges,  which are added at the checkout. \(hyperlinkTitle)
    \n
    Loans to California residents made or arranged pursuant to a California Lenders Law license.
    \n
    @ \(year) Afterpay
    """,
      lineHeightMultiple: lineHeightMultiple)
    termsAndConditionContentView.addHyperlink(title: hyperlinkTitle, link: "https://www.afterpay.com/installment-agreement")

    addSubviews()
    setupConstraints()
  }

  private func addSubviews() {
    view.addSubview(titleLabel)
    view.addSubview(verticalStackView)
    view.addSubview(termsAndConditionTitleLabel)
    view.addSubview(termsAndConditionContentView)
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

      verticalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 42),
      verticalStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      verticalStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

      termsAndConditionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      termsAndConditionTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      termsAndConditionTitleLabel.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 32),

      termsAndConditionContentView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
      termsAndConditionContentView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
      termsAndConditionContentView.topAnchor.constraint(equalTo: termsAndConditionTitleLabel.bottomAnchor, constant: 16),
    ])
  }

  private func createHeadlineView(index: Int, text: String) -> UIView {
    let superview = UIView()
    let indexLabel = HeadlineLabel()
    let headlineLabel = HeadlineLabel()
    let divider = DividerView()
    let horizontalStackView = UIStackView()

    indexLabel.text = "\(index)."
    headlineLabel.text = text

    indexLabel.numberOfLines = 1

    horizontalStackView.axis = .horizontal
    horizontalStackView.spacing = 16
    horizontalStackView.distribution = .fillProportionally
    horizontalStackView.translatesAutoresizingMaskIntoConstraints = false
    horizontalStackView.addArrangedSubview(indexLabel)
    horizontalStackView.addArrangedSubview(headlineLabel)

    indexLabel.adjustsFontSizeToFitWidth = true

    superview.addSubview(horizontalStackView)
    superview.addSubview(divider)

    NSLayoutConstraint.activate([
      horizontalStackView.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      horizontalStackView.topAnchor.constraint(equalTo: superview.topAnchor),
      horizontalStackView.trailingAnchor.constraint(equalTo: superview.trailingAnchor),

      divider.topAnchor.constraint(equalTo: horizontalStackView.bottomAnchor, constant: 16),
      divider.leadingAnchor.constraint(equalTo: superview.leadingAnchor),
      divider.trailingAnchor.constraint(equalTo: superview.trailingAnchor),
      divider.bottomAnchor.constraint(equalTo: superview.bottomAnchor),
    ])

    return superview
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
// swiftlint:enable line_length
