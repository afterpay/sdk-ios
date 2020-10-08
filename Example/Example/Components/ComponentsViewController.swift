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

// swiftlint:disable colon opening_brace
final class ComponentsViewController:
  UIViewController,
  UIPickerViewDataSource,
  UIPickerViewDelegate,
  UITextFieldDelegate
{
  // swiftlint:enable colon opening_brace

  private var scrollView: UIScrollView!
  private var pickerView: UIPickerView!
  private var minimumAmountTextField: UITextField!
  private var maximumAmountTextField: UITextField!
  private var localeTextField: UITextField!
  private let localeDelegate = LocaleDelegate() // swiftlint:disable:this weak_delegate

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

    let configurationView = UIView()
    configurationView.backgroundColor = .appBackground
    contentStack.addArrangedSubview(configurationView)

    let configurationStack = UIStackView()
    configurationStack.translatesAutoresizingMaskIntoConstraints = false
    configurationStack.axis = .vertical
    configurationStack.spacing = 8
    configurationView.addSubview(configurationStack)

    let contentGuide = view.readableContentGuide

    let configurationStackConstraints = [
      configurationStack.leadingAnchor.constraint(equalTo: contentGuide.leadingAnchor),
      configurationStack.trailingAnchor.constraint(equalTo: contentGuide.trailingAnchor),
      configurationStack.topAnchor.constraint(equalTo: configurationView.topAnchor, constant: 8),
      configurationStack.bottomAnchor.constraint(equalTo: configurationView.bottomAnchor, constant: -8),
    ]

    let configurationTitle = UILabel()
    configurationTitle.font = .preferredFont(forTextStyle: .title1)
    configurationTitle.adjustsFontForContentSizeCategory = true
    configurationTitle.textColor = .appLabel
    configurationTitle.text = "Stub Configuration"
    configurationStack.addArrangedSubview(configurationTitle)

    let minimumAmountTitle: UILabel = .bodyLabel
    minimumAmountTitle.text = "Minumum Amount:"
    configurationStack.addArrangedSubview(minimumAmountTitle)

    let doneSelector = #selector(endEditing)
    let done = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: doneSelector)
    let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let toolbar = UIToolbar(items: [spacer, done])

    pickerView = UIPickerView()
    pickerView.delegate = self
    pickerView.dataSource = self

    minimumAmountTextField = .roundedTextField
    minimumAmountTextField.text = configurationStub.minimumAmount
    minimumAmountTextField.delegate = self
    minimumAmountTextField.inputView = pickerView
    minimumAmountTextField.inputAccessoryView = toolbar
    configurationStack.addArrangedSubview(minimumAmountTextField)

    let maximumAmountTitle: UILabel = .bodyLabel
    maximumAmountTitle.text = "Maximum Amount:"
    configurationStack.addArrangedSubview(maximumAmountTitle)

    maximumAmountTextField = .roundedTextField
    maximumAmountTextField.text = configurationStub.maximumAmount
    maximumAmountTextField.delegate = self
    maximumAmountTextField.inputView = pickerView
    maximumAmountTextField.inputAccessoryView = toolbar
    configurationStack.addArrangedSubview(maximumAmountTextField)

    let localePicker = UIPickerView()

    let localeTitle: UILabel = .bodyLabel
    localeTitle.text = "Locale:"
    configurationStack.addArrangedSubview(localeTitle)

    localeTextField = .roundedTextField
    localeTextField.text = configurationStub.currencyCode
    localeTextField.inputView = localePicker
    localeTextField.inputAccessoryView = toolbar
    configurationStack.addArrangedSubview(localeTextField)

    localeDelegate.configure(updating: localeTextField, with: localePicker)

    let constraints = scrollViewConstraints
      + contentViewConstraints
      + stackConstraints
      + configurationStackConstraints

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

    let activeTextFieldOrigin = [minimumAmountTextField, maximumAmountTextField, localeTextField]
      .first { $0.isFirstResponder }
      .map { $0.frame.origin }

    if let origin = activeTextFieldOrigin, !view.frame.contains(origin) {
      let offset = CGPoint(x: 0, y: origin.y - keyboardHeight)
      scrollView.setContentOffset(offset, animated: true)
    }
  }

  // MARK: - UITextFieldDelegate

  func textFieldDidBeginEditing(_ textField: UITextField) {
    let title = { self.pickerView(self.pickerView, titleForRow: $0, forComponent: 0) }

    for row in 0...numberOfPickerRows where title(row) == textField.text {
      pickerView.selectRow(row, inComponent: 0, animated: false)
    }
  }

  // MARK: - UIPickerViewDataSource

  let numberOfPickerRows = 5000

  func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    numberOfPickerRows
  }

  // MARK: - UIPickerViewDelegate

  let noMinimum = "No Minimum"

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let isMinimum = minimumAmountTextField.isFirstResponder
    let isMaximum = maximumAmountTextField.isFirstResponder

    let format: (Int) -> String = { "\($0).00" }
    let formattedRow = isMaximum ? format(row + 1) : format(row)

    switch row {
    case .zero where isMinimum:
      return noMinimum
    default:
      return formattedRow
    }
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let isMinimum = minimumAmountTextField.isFirstResponder
    let textField = isMinimum ? minimumAmountTextField : maximumAmountTextField

    let title = self.pickerView(pickerView, titleForRow: row, forComponent: component)
    textField?.text = title

    if isMinimum {
      configurationStub.minimumAmount = title == noMinimum ? nil : title
    } else if let title = title {
      configurationStub.maximumAmount = title
    }
  }

}

private final class LocaleDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {

  private let localeIdentifiers = [
    "en_AU",
    "en_CA",
    "en_GB",
    "en_NZ",
    "en_US",
  ]

  private var textField: UITextField?

  func configure(updating textField: UITextField, with pickerView: UIPickerView) {
    self.textField = textField

    pickerView.delegate = self
    pickerView.dataSource = self

    if let row = localeIdentifiers.firstIndex(of: configurationStub.locale.identifier) {
      pickerView.selectRow(row, inComponent: 0, animated: false)
    }
  }

  // MARK: UIPickerViewDataSource

  func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    localeIdentifiers.count
  }

  // MARK: UIPickerViewDelegate

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    localeIdentifiers[row]
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let identifier = localeIdentifiers[row]

    textField?.text = identifier
    configurationStub.locale = Locale(identifier: identifier)
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
