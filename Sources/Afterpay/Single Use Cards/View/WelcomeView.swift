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

  enum Icon {
    case openingTime
    case thumbsUp
    case diamond
  }

  private var verticalStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.spacing = 12
    return stackView
  }()

  init(continueAction: Selector, aggregatorName: String) {
    super.init(frame: .zero)

    let continueButton = PrimaryButtonWithLogo()
    continueButton.addTarget(inputViewController, action: continueAction, for: .touchUpInside)

    let titleLabel = TitleLabel(with: "Pay in 4 parts. No fees.\nAlways interest-free.", fontSize: 32)

    let firstHeadline = createHeadlineView(icon: .openingTime, text: "4 easy payments, due every two weeks")
    let secondHeadline = createHeadlineView(icon: .thumbsUp, text: "Won't effect your credit score")
    let thirdHeadline = createHeadlineView(icon: .diamond, text: "Afterpay Rewards for on-time payments")

    let divider = DividerView()

    let hyperlinkText = "terms and conditions."
    let termsAndConditionTextView = BodyTextView()
    termsAndConditionTextView.configure(with: "By continuing you agree for \(aggregatorName) to share your data to complete your purchase. See \(hyperlinkText)")
    termsAndConditionTextView.addHyperlink(title: hyperlinkText, link: "https://www.afterpay.com/installment-agreement")

    verticalStackView.addArrangedSubview(firstHeadline)
    verticalStackView.addArrangedSubview(secondHeadline)
    verticalStackView.addArrangedSubview(thirdHeadline)

    addSubview(continueButton)
    addSubview(titleLabel)
    addSubview(verticalStackView)
    addSubview(divider)
    addSubview(termsAndConditionTextView)

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 32),
      titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),

      verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      verticalStackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 32),

      divider.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      divider.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      divider.topAnchor.constraint(equalTo: verticalStackView.bottomAnchor, constant: 24),

      termsAndConditionTextView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      termsAndConditionTextView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      termsAndConditionTextView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 24),

      continueButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
      continueButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
      continueButton.topAnchor.constraint(equalTo: termsAndConditionTextView.bottomAnchor, constant: 24),
      continueButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 64),
    ])
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

  // MARK: - Create subviews

  private func createHeadlineView(icon: Icon, text: String) -> UIStackView {
    let stackView = UIStackView()
    let headlineLabel = HeadlineLabel()
    let iconView = createIconView(icon: icon)

    headlineLabel.text = text

    stackView.axis = .horizontal
    stackView.spacing = 16

    stackView.addArrangedSubview(iconView)
    stackView.addArrangedSubview(headlineLabel)

    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }

  private func createIconView(icon: Icon) -> UIView {
    let iconView = UIView(frame: .zero)
    let svgConfiguration: SVGConfiguration

    switch icon {
    case .openingTime:
      svgConfiguration = OpeningTimeIconSVGConfiguration()
    case .thumbsUp:
      svgConfiguration = ThumbsUpIconSVGConfiguration()
    case .diamond:
      svgConfiguration = DiamondIconSVGConfiguration()
    }

    let iconSVGView = SVGView(svgConfiguration: svgConfiguration)

    iconView.layer.cornerRadius = 12
    iconView.backgroundColor = .black
    iconView.addSubview(iconSVGView)

    NSLayoutConstraint.activate([
      iconView.widthAnchor.constraint(equalToConstant: 32),
      iconView.heightAnchor.constraint(equalToConstant: 32),

      iconSVGView.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
      iconSVGView.centerXAnchor.constraint(equalTo: iconView.centerXAnchor),
    ])

    iconSVGView.translatesAutoresizingMaskIntoConstraints = false
    iconView.translatesAutoresizingMaskIntoConstraints = false

    return iconView
  }
}
