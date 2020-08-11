//
//  ComponentsViewController.swift
//  Example
//
//  Created by Adam Campbell on 30/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Foundation
import UIKit

final class ComponentsViewController: UIViewController {

  override func loadView() {
    let view = UIView()

    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.backgroundColor = .appBackground
    view.addSubview(scrollView)

    let scrollViewConstraints = [
      scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      scrollView.topAnchor.constraint(equalTo: view.topAnchor),
      scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ]

    let contentView = UIView()
    contentView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(contentView)

    let contentViewConstraints = [
      contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
      contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
      contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
    ]

    let contentStack = UIStackView()
    contentStack.translatesAutoresizingMaskIntoConstraints = false
    contentStack.axis = .vertical
    contentView.addSubview(contentStack)

    let layoutGuide = contentView.safeAreaLayoutGuide

    let stackConstraints = [
      contentStack.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      contentStack.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
      contentStack.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      contentStack.bottomAnchor.constraint(equalTo: layoutGuide.bottomAnchor),
    ]

    install(
      ContentStackViewController(stackTitle: "Light Content", userInterfaceStyle: .light),
      embed: contentStack.addArrangedSubview
    )

    install(
      ContentStackViewController(stackTitle: "Dark Content", userInterfaceStyle: .dark),
      embed: contentStack.addArrangedSubview
    )

    let configurationView = UIView()
    configurationView.backgroundColor = .appBackground
    contentStack.addArrangedSubview(configurationView)

    let configurationStack = UIStackView()
    configurationStack.translatesAutoresizingMaskIntoConstraints = false
    configurationStack.axis = .vertical
    configurationStack.spacing = 8
    configurationView.addSubview(configurationStack)

    let contentGuide = view.readableContentGuide

    let configurationStackConstraints = [
      configurationStack.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
      configurationStack.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
      configurationStack.topAnchor.constraint(equalTo: configurationView.topAnchor, constant: 8),
      configurationStack.bottomAnchor.constraint(equalTo: configurationView.bottomAnchor, constant: -8),
    ]

    let configurationTitle = UILabel()
    configurationTitle.font = .preferredFont(forTextStyle: .title1)
    configurationTitle.adjustsFontForContentSizeCategory = true
    configurationTitle.textColor = .appLabel
    configurationTitle.text = "Configuration"
    configurationStack.addArrangedSubview(configurationTitle)

    let minimumAmountTitle = UILabel()
    minimumAmountTitle.text = "Minumum Amount:"
    minimumAmountTitle.textColor = .appLabel
    minimumAmountTitle.adjustsFontForContentSizeCategory = true
    minimumAmountTitle.font = .preferredFont(forTextStyle: .body)
    configurationStack.addArrangedSubview(minimumAmountTitle)

    let minimumAmountTextField = UITextField()
    minimumAmountTextField.adjustsFontForContentSizeCategory = true
    minimumAmountTextField.textColor = .appLabel
    minimumAmountTextField.font = .preferredFont(forTextStyle: .body)
    minimumAmountTextField.borderStyle = .roundedRect
    minimumAmountTextField.text = "1"
    configurationStack.addArrangedSubview(minimumAmountTextField)

    let maximumAmountTitle = UILabel()
    maximumAmountTitle.text = "Minumum Amount:"
    maximumAmountTitle.textColor = .appLabel
    maximumAmountTitle.adjustsFontForContentSizeCategory = true
    maximumAmountTitle.font = .preferredFont(forTextStyle: .body)
    configurationStack.addArrangedSubview(maximumAmountTitle)

    let maximumAmountTextField = UITextField()
    maximumAmountTextField.adjustsFontForContentSizeCategory = true
    maximumAmountTextField.textColor = .appLabel
    maximumAmountTextField.font = .preferredFont(forTextStyle: .body)
    maximumAmountTextField.borderStyle = .roundedRect
    maximumAmountTextField.text = "1"
    configurationStack.addArrangedSubview(maximumAmountTextField)

    let constraints = scrollViewConstraints + contentViewConstraints + stackConstraints + configurationStackConstraints
    NSLayoutConstraint.activate(constraints)

    self.view = view
  }

  private final class ContentStackViewController: UIViewController, PriceBreakdownViewDelegate {

    let stackTitle: String

    init(stackTitle: String, userInterfaceStyle: UIUserInterfaceStyle) {
      self.stackTitle = stackTitle

      super.init(nibName: nil, bundle: nil)

      if #available(iOS 13.0, *) {
        overrideUserInterfaceStyle = userInterfaceStyle
      }
    }

    required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
      let view = UIView()
      view.backgroundColor = .appBackground

      let stack = UIStackView()
      stack.translatesAutoresizingMaskIntoConstraints = false
      stack.axis = .vertical
      stack.spacing = 8

      let titleLabel = UILabel()
      titleLabel.text = stackTitle
      titleLabel.font = .preferredFont(forTextStyle: .title1)
      titleLabel.adjustsFontForContentSizeCategory = true
      stack.addArrangedSubview(titleLabel)

      let badge = BadgeView()
      badge.widthAnchor.constraint(equalToConstant: 64).isActive = true

      let badgeStack = UIStackView(arrangedSubviews: [badge, UIView()])
      stack.addArrangedSubview(badgeStack)

      let priceBreakdown1 = PriceBreakdownView()
      priceBreakdown1.totalAmount = 100
      priceBreakdown1.delegate = self
      stack.addArrangedSubview(priceBreakdown1)

      let priceBreakdown2 = PriceBreakdownView()
      priceBreakdown2.totalAmount = 3000
      priceBreakdown2.delegate = self
      stack.addArrangedSubview(priceBreakdown2)

      let stackConstraints = [
        stack.leadingAnchor.constraint(equalTo: view.readableContentGuide.leadingAnchor),
        stack.trailingAnchor.constraint(equalTo: view.readableContentGuide.trailingAnchor),
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
      ]

      view.addSubview(stack)
      NSLayoutConstraint.activate(stackConstraints)

      self.view = view
    }

    func viewControllerForPresentation() -> UIViewController { self }

  }

}
