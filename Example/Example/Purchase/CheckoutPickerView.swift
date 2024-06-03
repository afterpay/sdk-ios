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
  func didSelectV3Checkout(_ controller: CheckoutPickerViewController)
  func didSelectV3CheckoutWithCashAppPay(_ controller: CheckoutPickerViewController)
}

final class CheckoutPickerViewController: UIViewController {

  private lazy var viewModel = makePickerViewModel()
  private lazy var pickerView = PickerView(viewModel: viewModel)

  private weak var delegate: CheckoutPickerControllerDelegate?

  init(delegate: CheckoutPickerControllerDelegate?) {
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

  // MARK: - Private

  private func makePickerViewModel() -> PickerViewModel {
    PickerViewModel(
      onButtonTapped: { [weak self] in
        guard let self else { return }
        delegate?.didSelectV3Checkout(self)
      },
      onButtonWithCashAppPayTapped: { [weak self] in
        guard let self else { return }
        delegate?.didSelectV3CheckoutWithCashAppPay(self)
      }
    )
  }
}

extension CheckoutPickerViewController {
  struct PickerViewModel {
    let onButtonTapped: () -> Void
    let onButtonWithCashAppPayTapped: () -> Void
  }

  struct PickerView: View {

    private let viewModel: PickerViewModel

    init(viewModel: PickerViewModel) {
      self.viewModel = viewModel
    }

    var body: some View {
      VStack(alignment: .leading) {
        Button("Button Checkout", action: viewModel.onButtonTapped).padding()
        Button("Button Checkout With Cash App Pay", action: viewModel.onButtonWithCashAppPayTapped).padding()
      }
    }
  }
}
