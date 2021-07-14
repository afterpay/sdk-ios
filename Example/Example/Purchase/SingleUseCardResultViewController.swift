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
  private(set) var cancellationClosure: CancellationClosure?
  private let merchantReferenceUpdateClosure: MerchantReferenceUpdateClosure

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
      "Merchant reference: <not set>",
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

  private lazy var cancellationButton: UIButton = {
    let button = UIButton(type: .roundedRect)
    button.setTitle("Cancel card", for: .normal)
    button.setTitle("Card cancelled", for: .disabled)
    button.addTarget(self, action: #selector(cancel), for: .touchUpInside)
    button.backgroundColor = .systemRed
    button.setTitleColor(.white, for: .normal)
    button.setTitleColor(.darkText, for: .disabled)
    button.layer.cornerRadius = 8
    return button
  }()

  private lazy var updateButton: UIButton = {
    let button = UIButton(type: .roundedRect)
    button.setTitle("Update merchant reference", for: .normal)
    button.addTarget(self, action: #selector(update), for: .touchUpInside)
    button.backgroundColor = .systemGreen
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 8
    return button
  }()

  // MARK: - Initializer

  init(
    details: CardDetails,
    authorizationExpiration: Date?,
    cancellationClosure: @escaping CancellationClosure,
    merchantReferenceUpdateClosure: @escaping MerchantReferenceUpdateClosure
  ) {
    self.details = details
    self.authorizationExpiration = authorizationExpiration
    self.cancellationClosure = cancellationClosure
    self.merchantReferenceUpdateClosure = merchantReferenceUpdateClosure

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
    (labels + [explanatoryHeaderLabel, explanatoryBodyLabel, cancellationButton, updateButton])
      .forEach(vStack.addArrangedSubview)
    vStack.setCustomSpacing(24, after: labels.last!)
    vStack.setCustomSpacing(24, after: explanatoryBodyLabel)
    vStack.setCustomSpacing(16, after: cancellationButton)
    setConstraints()
  }

  // MARK: - Actions

  @objc func cancel() {
    self.cancellationClosure? { [weak self] result in
      switch result {
      case .success:
        UIView.animate(withDuration: 0.3, animations: {
          self?.cancellationButton.isEnabled = false
          self?.cancellationButton.backgroundColor = .systemGray
        })
        self?.cancellationClosure = nil
      case .failure(let error):
        let alert = AlertFactory.alert(for: error.localizedDescription)
        self?.present(alert, animated: true)
      }
    }
  }

  @objc func update() {
    updateButton.setTitle("Updating ...", for: .normal)
    let newId = UUID().uuidString
    self.merchantReferenceUpdateClosure(UUID().uuidString) { [weak self] result in
      switch result {
      case .success:
        self?.updateButton.setTitle("Merchant reference updated!", for: .normal)
        self?.labels.last?.text = "Merchant reference: \(newId)"
      case .failure(let error):
        let alert = AlertFactory.alert(for: error.localizedDescription)
        self?.present(alert, animated: true)
      }
    }
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
      cancellationButton.heightAnchor.constraint(equalToConstant: 44),
      updateButton.heightAnchor.constraint(equalToConstant: 44),
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
