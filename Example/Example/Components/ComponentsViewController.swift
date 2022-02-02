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

  private var scrollView: UIScrollView!
  private var pickerView: UIPickerView!

  override func loadView() {
    let view = UIView()

    scrollView = UIScrollView()
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

    let constraints = scrollViewConstraints
      + contentViewConstraints
      + stackConstraints

    NSLayoutConstraint.activate(constraints)

    self.view = view
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    let notificationCenter = NotificationCenter.default
    let selector = #selector(adjustForKeyboard)

    notificationCenter.addObserver(
      self,
      selector: selector,
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )

    notificationCenter.addObserver(
      self,
      selector: selector,
      name: UIResponder.keyboardWillChangeFrameNotification,
      object: nil
    )
  }

  @objc private func endEditing() {
    view.endEditing(true)
  }

  @objc private func adjustForKeyboard(notification: Notification) {
    guard
      notification.name != UIResponder.keyboardWillHideNotification,
      let keyboardFrameInfo = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey],
      let keyboardHeight = (keyboardFrameInfo as? NSValue)?.cgRectValue.height
    else {
      scrollView.contentInset = .zero
      scrollView.scrollIndicatorInsets = .zero
      return
    }

    let insets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight, right: 0)
    scrollView.contentInset =  insets
    scrollView.scrollIndicatorInsets = insets
  }

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
    priceBreakdown1.introText = AfterpayIntroText.payInTitle
    priceBreakdown1.totalAmount = 100
    priceBreakdown1.delegate = self
    priceBreakdown1.moreInfoOptions = MoreInfoOptions(modalTheme: .white)
    stack.addArrangedSubview(priceBreakdown1)

    let priceBreakdown2 = PriceBreakdownView()
    priceBreakdown2.totalAmount = 100
    priceBreakdown2.delegate = self
    priceBreakdown2.showWithText = false
    priceBreakdown2.showInterestFreeText = false
    stack.addArrangedSubview(priceBreakdown2)

    let priceBreakdown3 = PriceBreakdownView()
    priceBreakdown3.totalAmount = 3000
    priceBreakdown3.delegate = self
    stack.addArrangedSubview(priceBreakdown3)

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
