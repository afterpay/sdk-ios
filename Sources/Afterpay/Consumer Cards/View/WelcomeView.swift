//
//  WelcomeView.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 9/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation
import UIKit

final class WelcomeView: UIView {

  private var verticalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 16
    return stackView
  }()

  private var termsAndConditionTextView: UITextView = {
    let textView = UITextView()

    let font = UIFont.systemFont(ofSize: 12, weight: .light)
    let fontMetrics = UIFontMetrics(forTextStyle: .footnote).scaledFont(for: font)

    let attributedString = NSMutableAttributedString(
      string: "By continuing you agree for Rakuten to share your data to complete your purchase. See terms and conditions",
      attributes: [
        .font: fontMetrics,
      ]
    )

    let range = (attributedString.string as NSString).range(of: "terms and conditions")
    attributedString.addAttribute(.link, value: "https://www.afterpay.com/installment-agreement", range: range)

    textView.adjustsFontForContentSizeCategory = true
    textView.translatesAutoresizingMaskIntoConstraints = false

    textView.attributedText = attributedString
    textView.isEditable = false
    textView.isSelectable = true
    textView.isScrollEnabled = false
    textView.textContainerInset = .zero
    textView.textContainer.lineFragmentPadding = .zero

    return textView
  }()

  private let headlineLabel: (_ text: String) -> UILabel = { text in
    let label = UILabel()
    label.text = text
    label.textAlignment = .left

    let font = UIFont.systemFont(ofSize: 14, weight: .semibold)
    label.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: font)

    label.adjustsFontForContentSizeCategory = true
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }

  init(continueAction: Selector) {
    super.init(frame: .zero)

    let continueButton = PrimaryButton(title: "Continue with Afterpay")
    continueButton.addTarget(inputViewController, action: continueAction, for: .touchUpInside)

    let titleLabel = TitleLabel(with: "Pay in 4 parts. No fees.\nAlways interest-free.", fontSize: 24)

    let firstHeadline = headlineLabel("4 easy payments, due every two weeks")
    let secondHeadline = headlineLabel("Won't effect your credit score")
    let thirdHeadline = headlineLabel("Afterpay Rewards for on-time payments")

    verticalStackView.addArrangedSubview(firstHeadline)
    verticalStackView.addArrangedSubview(secondHeadline)
    verticalStackView.addArrangedSubview(thirdHeadline)

    addSubview(continueButton)
    addSubview(titleLabel)
    addSubview(verticalStackView)
    addSubview(termsAndConditionTextView)

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      verticalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),

      termsAndConditionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      termsAndConditionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      termsAndConditionTextView.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 24),

      continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      continueButton.topAnchor.constraint(equalTo: termsAndConditionTextView.bottomAnchor, constant: 24),
      continueButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
    ])
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
