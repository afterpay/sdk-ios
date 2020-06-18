//
//  ViewController.swift
//  Example
//
//  Created by Adam Campbell on 12/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Combine
import Foundation
import UIKit

final class PaymentFlowController: UIViewController {

  private let ownedNavigationController: UINavigationController
  private var cancellables: Set<AnyCancellable> = []

  init(checkoutUrlProvider: @escaping (String) -> AnyPublisher<URL, Error>) {
    ownedNavigationController = UINavigationController()

    super.init(nibName: nil, bundle: nil)

    let dataEntryViewController = DataEntryViewController { [unowned self] email in
      let presentCheckout = { checkoutUrl in
        Afterpay.presentCheckout(over: self, loading: checkoutUrl) { token in
          print("Succeeded with \(token)")
        }
      }

      checkoutUrlProvider(email)
        .receive(on: DispatchQueue.main)
        .sink(receiveCompletion: { _ in }, receiveValue: presentCheckout)
        .store(in: &self.cancellables)
    }

    ownedNavigationController.setViewControllers([dataEntryViewController], animated: false)
  }

  override func loadView() {
    view = UIView()

    install(ownedNavigationController)
  }

  // MARK: Unavailable

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

}
