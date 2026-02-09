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
      ContentStackViewController(stackTitle: "Light Theme", userInterfaceStyle: .light),
      embed: contentStack.addArrangedSubview
    )

    let divider = UIView()
    divider.backgroundColor = .separator
    divider.translatesAutoresizingMaskIntoConstraints = false
    divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
    contentStack.addArrangedSubview(divider)

    install(
      ContentStackViewController(stackTitle: "Dark Theme", userInterfaceStyle: .dark),
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
    stack.spacing = 16

    let titleLabel = UILabel()
    titleLabel.text = stackTitle
    titleLabel.font = .preferredFont(forTextStyle: .title1)
    titleLabel.adjustsFontForContentSizeCategory = true
    stack.addArrangedSubview(titleLabel)

    if Afterpay.enabled {
      // MARK: - BadgeView (not available in Cash App Afterpay regions)
      if !Afterpay.isCashAppAfterpayRegion {
        stack.addArrangedSubview(sectionHeader("BadgeView"))

        let badgeDefault = BadgeView(colorScheme: .static(.default))
        badgeDefault.widthAnchor.constraint(equalToConstant: 64).isActive = true
        stack.addArrangedSubview(labeledView(badgeDefault, caption: "BadgeView - default"))

        let badgeAlt = BadgeView(colorScheme: .static(.alt))
        badgeAlt.widthAnchor.constraint(equalToConstant: 64).isActive = true
        stack.addArrangedSubview(labeledView(badgeAlt, caption: "BadgeView - alt"))

        let badgeDarkMono = BadgeView(colorScheme: .static(.darkMono))
        badgeDarkMono.widthAnchor.constraint(equalToConstant: 64).isActive = true
        stack.addArrangedSubview(labeledView(badgeDarkMono, caption: "BadgeView - darkMono"))

        let badgeLightMono = BadgeView(colorScheme: .static(.lightMono))
        badgeLightMono.widthAnchor.constraint(equalToConstant: 64).isActive = true
        stack.addArrangedSubview(labeledView(badgeLightMono, caption: "BadgeView - lightMono"))
      }

      // MARK: - LockupView
      stack.addArrangedSubview(sectionHeader("LockupView"))

      let lockupDefault = LockupView(colorScheme: .static(.default))
      lockupDefault.widthAnchor.constraint(equalToConstant: 64).isActive = true
      stack.addArrangedSubview(labeledView(lockupDefault, caption: "LockupView - default"))

      let lockupAlt = LockupView(colorScheme: .static(.alt))
      lockupAlt.widthAnchor.constraint(equalToConstant: 64).isActive = true
      stack.addArrangedSubview(labeledView(lockupAlt, caption: "LockupView - alt"))

      let lockupDarkMono = LockupView(colorScheme: .static(.darkMono))
      lockupDarkMono.widthAnchor.constraint(equalToConstant: 64).isActive = true
      stack.addArrangedSubview(labeledView(lockupDarkMono, caption: "LockupView - darkMono"))

      let lockupLightMono = LockupView(colorScheme: .static(.lightMono))
      lockupLightMono.widthAnchor.constraint(equalToConstant: 64).isActive = true
      stack.addArrangedSubview(labeledView(lockupLightMono, caption: "LockupView - lightMono"))

      // MARK: - PaymentButton
      stack.addArrangedSubview(sectionHeader("PaymentButton"))

      // buyNow - all color palettes
      let buyNowDefault = PaymentButton(colorScheme: .static(.default), buttonKind: .buyNow)
      stack.addArrangedSubview(labeledView(buyNowDefault, caption: "PaymentButton - buyNow, default"))

      let buyNowAlt = PaymentButton(colorScheme: .static(.alt), buttonKind: .buyNow)
      stack.addArrangedSubview(labeledView(buyNowAlt, caption: "PaymentButton - buyNow, alt"))

      let buyNowDarkMono = PaymentButton(colorScheme: .static(.darkMono), buttonKind: .buyNow)
      stack.addArrangedSubview(labeledView(buyNowDarkMono, caption: "PaymentButton - buyNow, darkMono"))

      let buyNowLightMono = PaymentButton(colorScheme: .static(.lightMono), buttonKind: .buyNow)
      stack.addArrangedSubview(labeledView(buyNowLightMono, caption: "PaymentButton - buyNow, lightMono"))

      // checkout - all color palettes
      let checkoutDefault = PaymentButton(colorScheme: .static(.default), buttonKind: .checkout)
      stack.addArrangedSubview(labeledView(checkoutDefault, caption: "PaymentButton - checkout, default"))

      let checkoutAlt = PaymentButton(colorScheme: .static(.alt), buttonKind: .checkout)
      stack.addArrangedSubview(labeledView(checkoutAlt, caption: "PaymentButton - checkout, alt"))

      let checkoutDarkMono = PaymentButton(colorScheme: .static(.darkMono), buttonKind: .checkout)
      stack.addArrangedSubview(labeledView(checkoutDarkMono, caption: "PaymentButton - checkout, darkMono"))

      let checkoutLightMono = PaymentButton(colorScheme: .static(.lightMono), buttonKind: .checkout)
      stack.addArrangedSubview(labeledView(checkoutLightMono, caption: "PaymentButton - checkout, lightMono"))

      // payNow - all color palettes
      let payNowDefault = PaymentButton(colorScheme: .static(.default), buttonKind: .payNow)
      stack.addArrangedSubview(labeledView(payNowDefault, caption: "PaymentButton - payNow, default"))

      let payNowAlt = PaymentButton(colorScheme: .static(.alt), buttonKind: .payNow)
      stack.addArrangedSubview(labeledView(payNowAlt, caption: "PaymentButton - payNow, alt"))

      let payNowDarkMono = PaymentButton(colorScheme: .static(.darkMono), buttonKind: .payNow)
      stack.addArrangedSubview(labeledView(payNowDarkMono, caption: "PaymentButton - payNow, darkMono"))

      let payNowLightMono = PaymentButton(colorScheme: .static(.lightMono), buttonKind: .payNow)
      stack.addArrangedSubview(labeledView(payNowLightMono, caption: "PaymentButton - payNow, lightMono"))

      // continueWith - all color palettes
      let continueWithDefault = PaymentButton(colorScheme: .static(.default), buttonKind: .continueWith)
      stack.addArrangedSubview(labeledView(continueWithDefault, caption: "PaymentButton - continueWith, default"))

      let continueWithAlt = PaymentButton(colorScheme: .static(.alt), buttonKind: .continueWith)
      stack.addArrangedSubview(labeledView(continueWithAlt, caption: "PaymentButton - continueWith, alt"))

      let continueWithDarkMono = PaymentButton(colorScheme: .static(.darkMono), buttonKind: .continueWith)
      stack.addArrangedSubview(labeledView(continueWithDarkMono, caption: "PaymentButton - continueWith, darkMono"))

      let continueWithLightMono = PaymentButton(colorScheme: .static(.lightMono), buttonKind: .continueWith)
      stack.addArrangedSubview(labeledView(continueWithLightMono, caption: "PaymentButton - continueWith, lightMono"))

      // MARK: - PriceBreakdownView
      stack.addArrangedSubview(sectionHeader("PriceBreakdownView"))

      // Logo type variations
      let priceBreakdownBadge = PriceBreakdownView()
      priceBreakdownBadge.totalAmount = 100
      priceBreakdownBadge.delegate = self
      priceBreakdownBadge.logoType = .badge
      stack.addArrangedSubview(labeledView(priceBreakdownBadge, caption: "PriceBreakdownView - logoType: badge"))

      let priceBreakdownLockup = PriceBreakdownView()
      priceBreakdownLockup.totalAmount = 100
      priceBreakdownLockup.delegate = self
      priceBreakdownLockup.logoType = .lockup
      stack.addArrangedSubview(labeledView(priceBreakdownLockup, caption: "PriceBreakdownView - logoType: lockup"))

      let priceBreakdownCompact = PriceBreakdownView()
      priceBreakdownCompact.totalAmount = 100
      priceBreakdownCompact.delegate = self
      priceBreakdownCompact.logoType = .compactBadge
      stack.addArrangedSubview(labeledView(priceBreakdownCompact, caption: "PriceBreakdownView - logoType: compactBadge"))

      // Intro text variations
      let priceBreakdownOr = PriceBreakdownView()
      priceBreakdownOr.totalAmount = 100
      priceBreakdownOr.delegate = self
      priceBreakdownOr.introText = .or
      stack.addArrangedSubview(labeledView(priceBreakdownOr, caption: "PriceBreakdownView - introText: or"))

      let priceBreakdownPayIn = PriceBreakdownView()
      priceBreakdownPayIn.totalAmount = 100
      priceBreakdownPayIn.delegate = self
      priceBreakdownPayIn.introText = .payIn
      stack.addArrangedSubview(labeledView(priceBreakdownPayIn, caption: "PriceBreakdownView - introText: payIn"))

      let priceBreakdownMake = PriceBreakdownView()
      priceBreakdownMake.totalAmount = 100
      priceBreakdownMake.delegate = self
      priceBreakdownMake.introText = .make
      stack.addArrangedSubview(labeledView(priceBreakdownMake, caption: "PriceBreakdownView - introText: make"))

      let priceBreakdownPay = PriceBreakdownView()
      priceBreakdownPay.totalAmount = 100
      priceBreakdownPay.delegate = self
      priceBreakdownPay.introText = .pay
      stack.addArrangedSubview(labeledView(priceBreakdownPay, caption: "PriceBreakdownView - introText: pay"))

      let priceBreakdownIn = PriceBreakdownView()
      priceBreakdownIn.totalAmount = 100
      priceBreakdownIn.delegate = self
      priceBreakdownIn.introText = .in
      stack.addArrangedSubview(labeledView(priceBreakdownIn, caption: "PriceBreakdownView - introText: in"))

      let priceBreakdownEmpty = PriceBreakdownView()
      priceBreakdownEmpty.totalAmount = 100
      priceBreakdownEmpty.delegate = self
      priceBreakdownEmpty.introText = .empty
      stack.addArrangedSubview(labeledView(priceBreakdownEmpty, caption: "PriceBreakdownView - introText: empty"))

      // Display options
      let priceBreakdownNoWith = PriceBreakdownView()
      priceBreakdownNoWith.totalAmount = 100
      priceBreakdownNoWith.delegate = self
      priceBreakdownNoWith.showWithText = false
      stack.addArrangedSubview(labeledView(priceBreakdownNoWith, caption: "PriceBreakdownView - showWithText: false"))

      let priceBreakdownNoInterest = PriceBreakdownView()
      priceBreakdownNoInterest.totalAmount = 100
      priceBreakdownNoInterest.delegate = self
      priceBreakdownNoInterest.showInterestFreeText = false
      stack.addArrangedSubview(labeledView(priceBreakdownNoInterest, caption: "PriceBreakdownView - showInterestFreeText: false"))

      let priceBreakdownMinimal = PriceBreakdownView()
      priceBreakdownMinimal.totalAmount = 100
      priceBreakdownMinimal.delegate = self
      priceBreakdownMinimal.showWithText = false
      priceBreakdownMinimal.showInterestFreeText = false
      stack.addArrangedSubview(labeledView(priceBreakdownMinimal, caption: "PriceBreakdownView - minimal (no with/interest)"))

      // Amount edge cases
      let priceBreakdownOutOfRange = PriceBreakdownView()
      priceBreakdownOutOfRange.totalAmount = 5000
      priceBreakdownOutOfRange.delegate = self
      stack.addArrangedSubview(labeledView(priceBreakdownOutOfRange, caption: "PriceBreakdownView - amount out of range"))

      // Logo color schemes
      let priceBreakdownLogoDefault = PriceBreakdownView()
      priceBreakdownLogoDefault.totalAmount = 100
      priceBreakdownLogoDefault.delegate = self
      priceBreakdownLogoDefault.logoColorScheme = .static(.default)
      stack.addArrangedSubview(labeledView(priceBreakdownLogoDefault, caption: "PriceBreakdownView - logoColorScheme: default"))

      let priceBreakdownLogoAlt = PriceBreakdownView()
      priceBreakdownLogoAlt.totalAmount = 100
      priceBreakdownLogoAlt.delegate = self
      priceBreakdownLogoAlt.logoColorScheme = .static(.alt)
      stack.addArrangedSubview(labeledView(priceBreakdownLogoAlt, caption: "PriceBreakdownView - logoColorScheme: alt"))

      let priceBreakdownLogoDarkMono = PriceBreakdownView()
      priceBreakdownLogoDarkMono.totalAmount = 100
      priceBreakdownLogoDarkMono.delegate = self
      priceBreakdownLogoDarkMono.logoColorScheme = .static(.darkMono)
      stack.addArrangedSubview(labeledView(priceBreakdownLogoDarkMono, caption: "PriceBreakdownView - logoColorScheme: darkMono"))

      let priceBreakdownLogoLightMono = PriceBreakdownView()
      priceBreakdownLogoLightMono.totalAmount = 100
      priceBreakdownLogoLightMono.delegate = self
      priceBreakdownLogoLightMono.logoColorScheme = .static(.lightMono)
      stack.addArrangedSubview(labeledView(priceBreakdownLogoLightMono, caption: "PriceBreakdownView - logoColorScheme: lightMono"))
    }

    let stackConstraints = [
      stack.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
      stack.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
      stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
      stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
    ]

    view.addSubview(stack)
    NSLayoutConstraint.activate(stackConstraints)

    self.view = view
  }

  func viewControllerForPresentation() -> UIViewController { self }

  private func sectionHeader(_ title: String) -> UIView {
    let container = UIView()

    let label = UILabel()
    label.text = title
    label.font = .preferredFont(forTextStyle: .headline)
    label.textColor = .label
    label.adjustsFontForContentSizeCategory = true
    label.translatesAutoresizingMaskIntoConstraints = false

    container.addSubview(label)
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
      label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
      label.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
      label.bottomAnchor.constraint(equalTo: container.bottomAnchor),
    ])

    return container
  }

  private func labeledView(_ view: UIView, caption: String) -> UIView {
    let container = UIStackView()
    container.axis = .vertical
    container.alignment = .leading
    container.spacing = 4

    let label = UILabel()
    label.text = caption
    label.font = .preferredFont(forTextStyle: .caption1)
    label.textColor = .secondaryLabel
    label.adjustsFontForContentSizeCategory = true

    container.addArrangedSubview(view)
    container.addArrangedSubview(label)

    return container
  }

}
