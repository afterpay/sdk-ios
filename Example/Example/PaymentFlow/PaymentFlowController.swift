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
      let navigationController = self.ownedNavigationController

      let presentCheckout = { checkoutUrl in
        Afterpay.presentCheckout(
          over: self,
          loading: checkoutUrl,
          cancelHandler: {
            let messageViewController = MessageViewController(message: "Payment cancelled")
            navigationController.pushViewController(messageViewController, animated: true)
          },
          successHandler: { token in
            let message = "Succeeded with token: \(token)"
            let messageViewController = MessageViewController(message: message)
            navigationController.pushViewController(messageViewController, animated: true)
          }
        )
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
