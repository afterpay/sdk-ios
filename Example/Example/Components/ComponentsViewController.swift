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
    let scrollView = UIScrollView()
    scrollView.backgroundColor = .appBackground

    let layoutGuide = scrollView.readableContentGuide

    let contentStack = UIStackView()
    contentStack.translatesAutoresizingMaskIntoConstraints = false
    contentStack.axis = .vertical

    scrollView.addSubview(contentStack)

    let stackConstraints = [
      contentStack.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
      contentStack.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
      contentStack.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      contentStack.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
    ]

    install(
      ContentStackViewController(stackTitle: "Light Content", userInterfaceStyle: .light),
      embed: contentStack.addArrangedSubview
    )

    install(
      ContentStackViewController(stackTitle: "Dark Content", userInterfaceStyle: .dark),
      embed: contentStack.addArrangedSubview
    )

    NSLayoutConstraint.activate(stackConstraints)

    self.view = scrollView
  }

  private final class ContentStackViewController: UIViewController {

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

      let priceBreakdown = PriceBreakdownView()
      stack.addArrangedSubview(priceBreakdown)

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

  }

}
