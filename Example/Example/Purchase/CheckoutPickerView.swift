//
//  CheckoutPickerView.swift
//  Example
//
//  Created by Mark Mroz on 2024-06-03.
//  Copyright © 2024 Afterpay. All rights reserved.
//

import SwiftUI

protocol CheckoutPickerControllerDelegate: AnyObject {
  func didSelectCancel(_ controller: CheckoutPickerViewController)
  func didSelectCheckoutOption(_ controller: CheckoutPickerViewController, option: CheckoutPickerOption)
}

enum CheckoutPickerOption {
  case v1
  case v2
  case v3
}

final class CheckoutPickerViewController: UIViewController {

  private let selectedOption: CheckoutPickerOption

  private weak var delegate: CheckoutPickerControllerDelegate?

  private lazy var viewModel = makePickerViewModel()
  private lazy var pickerView = PickerView(viewModel: viewModel)

  init(selectedOption: CheckoutPickerOption, delegate: CheckoutPickerControllerDelegate?) {
    self.selectedOption = selectedOption
    self.delegate = delegate
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    let container = UIView(frame: .zero)
    let view = UIHostingController(rootView: pickerView).view!
    container.addSubview(view)
    container.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      container.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      container.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      container.topAnchor.constraint(equalTo: view.topAnchor),
      container.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])

    self.view = view
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupNavbar()
  }

  private func setupNavbar() {
    let cancelButton = UIBarButtonItem(
      title: "Close",
      style: .plain,
      target: self,
      action: #selector(onCancelTapped)
    )
    navigationItem.setRightBarButton(cancelButton, animated: false)
  }

  // MARK: - Actions

  @objc private func onCancelTapped() {
    delegate?.didSelectCancel(self)
  }
}

// MARK: View Building

extension CheckoutPickerViewController {
  private func makePickerViewModel() -> PickerViewModel {
    PickerViewModel(
      onButtonTapped: { [weak self] option in
        guard let self else { return }
        delegate?.didSelectCheckoutOption(self, option: option)
      },
      selectedOption: selectedOption
    )
  }
}

extension CheckoutPickerViewController {
  struct PickerViewModel {
    let onButtonTapped: (CheckoutPickerOption) -> Void
    let selectedOption: CheckoutPickerOption
  }

  struct PickerView: View {

    let viewModel: PickerViewModel

    var body: some View {
      VStack {
        CustomButton(
          "V1",
          isSelected: viewModel.selectedOption == .v1,
          action: { viewModel.onButtonTapped(.v1) }
        )
        CustomButton(
          "V2 - Express",
          isSelected: viewModel.selectedOption == .v2,
          action: { viewModel.onButtonTapped(.v2) }
        )
        CustomButton(
          "V3 - Button",
          isSelected: viewModel.selectedOption == .v3,
          action: { viewModel.onButtonTapped(.v3) }
        )
        Spacer()
      }.padding()
    }
  }
}

// MARK: - Custom button Styling

public struct CustomButton: View {
  private let text: String
  private let action: (() -> Void)

  private let isSelected: Bool

  private var icon: Image {
    Image(systemName: isSelected ? "checkmark.circle" : "circle")
  }

  public var body: some View {
    Button(action: action) {
      HStack {
        Text(text).font(.body)
        Spacer()
        icon
      }
      .foregroundColor(.white)
      .frame(maxWidth: .infinity)
      .padding(8)
    }
    .buttonStyle(CustomButtonStyle(isSelected: isSelected))
  }

  public init(_ text: String, isSelected: Bool, action: @escaping () -> Void) {
    self.text = text
    self.action = action
    self.isSelected = isSelected
  }
}

private struct CustomButtonStyle: ButtonStyle {
  let isSelected: Bool
  @ViewBuilder
  func makeBody(configuration: Configuration) -> some View {
    let background = configuration.isPressed ?  Color.gray : Color.blue
    configuration.label
      .foregroundColor(.white)
      .background(background)
      .cornerRadius(8)
  }
}
