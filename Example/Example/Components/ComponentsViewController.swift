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

    let layoutGuide = contentView.readableContentGuide

    let stackConstraints = [
      contentStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      contentStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
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

    let constraints = scrollViewConstraints + contentViewConstraints + stackConstraints
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
