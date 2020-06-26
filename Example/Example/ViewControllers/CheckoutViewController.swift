//
//  PayWithAfterpayViewController.swift
//  Example
//
//  Created by Adam Campbell on 12/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import UIKit

final class CheckoutViewController: UIViewController {

  typealias URLProvider = (
    _ completion: @escaping (Result<URL, Error>) -> Void
  ) -> Void

  private let urlProvider: URLProvider
  private var checkoutView: CheckoutView { view as! CheckoutView }

  init(urlProvider: @escaping URLProvider) {
    self.urlProvider = urlProvider

    super.init(nibName: nil, bundle: nil)

    self.title = "Swift Checkout"
  }

  override func loadView() {
    view = CheckoutView()
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    checkoutView.payButton.addTarget(self, action: #selector(didTapPay), for: .touchUpInside)
  }

  // MARK: Checkout

  @objc private func didTapPay() {
    let presentCheckout = { [unowned self] url in
      Afterpay.presentCheckout(
        over: self,
        loading: url,
        successHandler: { _ in }
      )
    }

    let presentError = { [unowned self] (error: Error) in
      let alert = AlertFactory.alert(for: error)
      self.present(alert, animated: true, completion: nil)
    }

    urlProvider { result in
      var action = {}

      switch result {
      case .success(let url):
        action = { presentCheckout(url) }
      case .failure(let error):
      action = { presentError(error) }
      }

      DispatchQueue.main.async(execute: action)
    }
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
