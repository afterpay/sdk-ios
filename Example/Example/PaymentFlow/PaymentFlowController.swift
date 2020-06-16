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

  init(urlProvider: @escaping (String) -> AnyPublisher<URL, Error>) {
    ownedNavigationController = UINavigationController()

    super.init(nibName: nil, bundle: nil)

    let dataEntry = DataEntryViewController { [weak self] email in
      let cancellable = urlProvider(email)
        .receive(on: DispatchQueue.main)
        .sink(
          receiveCompletion: { _ in },
          receiveValue: { url in
            let checkout = CheckoutViewController(checkoutUrl: url)
            self?.ownedNavigationController.pushViewController(checkout, animated: true)
          }
        )

      self?.cancellables.insert(cancellable)
    }

    ownedNavigationController.setViewControllers([dataEntry], animated: false)
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
