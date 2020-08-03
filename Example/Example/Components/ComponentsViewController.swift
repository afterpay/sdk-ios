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

    // Light Content

    let lightContentView = UIView()
    lightContentView.backgroundColor = .white

    contentStack.addArrangedSubview(lightContentView)

    let lightContentStack = UIStackView()
    lightContentStack.translatesAutoresizingMaskIntoConstraints = false
    lightContentStack.axis = .vertical
    lightContentStack.spacing = 8

    lightContentView.addSubview(lightContentStack)

    let lightContentStackConstraints = [
      lightContentStack.leadingAnchor.constraint(equalTo: lightContentView.readableContentGuide.leadingAnchor),
      lightContentStack.trailingAnchor.constraint(equalTo: lightContentView.readableContentGuide.trailingAnchor),
      lightContentStack.topAnchor.constraint(equalTo: lightContentView.topAnchor, constant: 8),
      lightContentStack.bottomAnchor.constraint(equalTo: lightContentView.bottomAnchor, constant: -8),
    ]

    let lightContentLabel = UILabel()
    lightContentLabel.text = "Light components:"
    lightContentStack.addArrangedSubview(lightContentLabel)

    let lightBadge = BadgeView(style: .whiteOnBlack)
    let lightBadgeConstraints = [lightBadge.widthAnchor.constraint(equalToConstant: 64)]

    let lightBadgeStack = UIStackView(arrangedSubviews: [lightBadge, UIView()])
    lightContentStack.addArrangedSubview(lightBadgeStack)

    let priceBreakdown = PriceBreakdownView()
    lightContentStack.addArrangedSubview(priceBreakdown)

    // Dark Content

    let darkContentView = UIView()
    darkContentView.backgroundColor = .black

    contentStack.addArrangedSubview(darkContentView)

    let darkContentStack = UIStackView()
    darkContentStack.translatesAutoresizingMaskIntoConstraints = false
    darkContentStack.axis = .vertical
    darkContentStack.spacing = 8

    darkContentView.addSubview(darkContentStack)

    let darkContentStackConstraints = [
      darkContentStack.leadingAnchor.constraint(equalTo: darkContentView.readableContentGuide.leadingAnchor),
      darkContentStack.trailingAnchor.constraint(equalTo: darkContentView.readableContentGuide.trailingAnchor),
      darkContentStack.topAnchor.constraint(equalTo: darkContentView.topAnchor, constant: 8),
      darkContentStack.bottomAnchor.constraint(equalTo: darkContentView.bottomAnchor, constant: -8),
    ]

    let darkContentLabel = UILabel()
    darkContentLabel.textColor = .white
    darkContentLabel.text = "Dark components:"
    darkContentStack.addArrangedSubview(darkContentLabel)

    let darkBadge = BadgeView(style: .blackOnWhite)
    let darkBadgeConstraints = [darkBadge.widthAnchor.constraint(equalToConstant: 64)]

    let darkBadgeStack = UIStackView(arrangedSubviews: [darkBadge, UIView()])
    darkContentStack.addArrangedSubview(darkBadgeStack)

    NSLayoutConstraint.activate(
      stackConstraints +
      lightContentStackConstraints +
      lightBadgeConstraints +
      darkContentStackConstraints +
      darkBadgeConstraints
    )

    self.view = scrollView
  }

}
