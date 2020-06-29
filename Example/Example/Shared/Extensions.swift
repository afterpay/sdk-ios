//
//  Helpers.swift
//  Example
//
//  Created by Adam Campbell on 12/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

// Taken from / inspired by: https://rambo.codes/posts/2020-02-20-mvc-with-sugar
extension UIViewController {
  func install(_ child: UIViewController, into view: UIView) {
    addChild(child)

    child.view.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(child.view)

    NSLayoutConstraint.activate([
      child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      child.view.topAnchor.constraint(equalTo: view.topAnchor),
      child.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    child.didMove(toParent: self)
  }
}

extension NSLayoutAnchor {
  @objc func constraint(
    equalTo anchor: NSLayoutAnchor,
    constant: CGFloat,
    priority: UILayoutPriority
  ) -> NSLayoutConstraint {
    let layoutConstraint = constraint(equalTo: anchor, constant: constant)
    layoutConstraint.priority = priority
    return layoutConstraint
  }
}
