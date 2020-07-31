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
    if #available(iOS 13.0, *) {
      scrollView.backgroundColor = .systemBackground
    } else {
      scrollView.backgroundColor = .white
    }

    let layoutGuide = scrollView.readableContentGuide

    let contentStack = UIStackView()
    contentStack.translatesAutoresizingMaskIntoConstraints = false
    contentStack.axis = .vertical

    scrollView.addSubview(contentStack)

    let stackConstraints = [
      contentStack.leadingAnchor.constraint(equalTo: layoutGuide.leadingAnchor),
      contentStack.trailingAnchor.constraint(equalTo: layoutGuide.trailingAnchor),
      contentStack.topAnchor.constraint(equalTo: layoutGuide.topAnchor),
      contentStack.widthAnchor.constraint(equalTo: layoutGuide.widthAnchor),
    ]

    let lightContentView = UIView()
    lightContentView.backgroundColor = .white

    contentStack.addArrangedSubview(lightContentView)

    let lightContentStack = UIStackView()
    lightContentStack.translatesAutoresizingMaskIntoConstraints = false
    lightContentStack.axis = .vertical
    lightContentStack.spacing = 8

    lightContentView.addSubview(lightContentStack)

    let lightContentStackConstraints = [
      lightContentStack.leadingAnchor.constraint(equalTo: lightContentView.leadingAnchor),
      lightContentStack.trailingAnchor.constraint(equalTo: lightContentView.trailingAnchor),
      lightContentStack.topAnchor.constraint(equalTo: lightContentView.topAnchor),
      lightContentStack.bottomAnchor.constraint(equalTo: lightContentView.bottomAnchor),
    ]

    let lightContentLabel = UILabel()
    lightContentLabel.text = "Light components:"
    lightContentStack.addArrangedSubview(lightContentLabel)

    let badge = BadgeView()
    let badgeConstraints = [badge.widthAnchor.constraint(equalToConstant: 64)]

    let badgeStack = UIStackView(arrangedSubviews: [badge, UIView()])
    lightContentStack.addArrangedSubview(badgeStack)

    NSLayoutConstraint.activate(stackConstraints + lightContentStackConstraints + badgeConstraints)

    self.view = scrollView
  }

}
