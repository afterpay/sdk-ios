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

  init(continueAction: Selector) {
    super.init(frame: .zero)

    let continueButton = UIButton()
    continueButton.setTitle("Continue", for: .normal)
    continueButton.setTitleColor(.blue, for: .normal)
    continueButton.addTarget(inputViewController, action: continueAction, for: .touchDown)

    continueButton.translatesAutoresizingMaskIntoConstraints = false
    addSubview(continueButton)

    NSLayoutConstraint.activate([
      continueButton.leadingAnchor.constraint(equalTo: leadingAnchor),
      continueButton.trailingAnchor.constraint(equalTo: trailingAnchor),
      continueButton.topAnchor.constraint(equalTo: topAnchor),
      continueButton.bottomAnchor.constraint(equalTo: bottomAnchor),
    ])
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
}
