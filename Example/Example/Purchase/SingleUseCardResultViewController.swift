//
//  SingleUseCardResultViewController.swift
//  Example
//
//  Created by Chris Kolbu on 13/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Afterpay
import Foundation
import UIKit

final class SingleUseCardResultViewController: UIViewController {

  // MARK: - Properties
  private let details: CardDetails
  private let authorizationExpiration: Date?

  private let vStack: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 8
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  private lazy var labels: [UILabel] = {
    let strings = [
      "Card number: \(details.cardNumber)",
      "CVC: \(details.cvc)",
      "Expiration: \(details.expiryMonth)/\(details.expiryYear)",
      "Virtual card expiry: \(authorizationExpiration?.shortDuration ?? "Unavailable")",
    ]

    return strings.map { string in
      let label = UILabel()
      label.numberOfLines = 0
      label.font = .preferredFont(forTextStyle: .body)
      label.adjustsFontForContentSizeCategory = true
      label.translatesAutoresizingMaskIntoConstraints = false
      label.textColor = .systemGray
      label.text = string
      return label
    }
  }()

  private lazy var explanatoryHeaderLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = .preferredFont(forTextStyle: .headline)
    label.adjustsFontForContentSizeCategory = true
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "Next steps"
    return label
  }()

  private lazy var explanatoryBodyLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = .preferredFont(forTextStyle: .body)
    label.adjustsFontForContentSizeCategory = true
    label.translatesAutoresizingMaskIntoConstraints = false
    label.text = "After the user has completed their Afterpay checkout, "
      + "you will have until the `virtual card expiry` to perform an authorisation on the card. "
      + "This completes the purchase."
    return label
  }()

  // MARK: - Initializer

  init(details: CardDetails, authorizationExpiration: Date?) {
    self.details = details
    self.authorizationExpiration = authorizationExpiration

    super.init(nibName: nil, bundle: nil)

    self.title = "Single Use Card"
  }

  // MARK: - View lifecycle

  override func loadView() {
    view = UIScrollView()
    view.backgroundColor = .appBackground
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(vStack)
    (labels + [explanatoryHeaderLabel, explanatoryBodyLabel]).forEach(vStack.addArrangedSubview)
    vStack.setCustomSpacing(24, after: labels.last!)
    setConstraints()
  }

  // MARK: - Constraints

  private func setConstraints() {
    let scrollView = view as! UIScrollView
    NSLayoutConstraint.activate([
      vStack.topAnchor.constraint(
        equalToSystemSpacingBelow: scrollView.contentLayoutGuide.topAnchor,
        multiplier: 2
      ),
      vStack.leadingAnchor.constraint(
        equalToSystemSpacingAfter: scrollView.contentLayoutGuide.leadingAnchor,
        multiplier: 2
      ),
      scrollView.contentLayoutGuide.trailingAnchor.constraint(
        equalToSystemSpacingAfter: vStack.trailingAnchor,
        multiplier: 2
      ),
      scrollView.contentLayoutGuide.bottomAnchor.constraint(
        greaterThanOrEqualToSystemSpacingBelow: vStack.bottomAnchor,
        multiplier: 2
      ),
      scrollView.contentLayoutGuide.widthAnchor.constraint(
        equalTo: scrollView.frameLayoutGuide.widthAnchor
      ),
    ])
  }

  @available(*, unavailable)
  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Private extensions

private extension Date {
  var shortDuration: String? {
    let formatter = DateComponentsFormatter()
    formatter.allowedUnits = [.hour, .minute, .second]
    formatter.maximumUnitCount = 3
    formatter.unitsStyle = .abbreviated

    return formatter.string(from: Date(), to: self)
  }
}
