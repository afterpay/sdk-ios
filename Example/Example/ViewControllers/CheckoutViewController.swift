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
  private var segmentedControl: UISegmentedControl {
    navigationItem.titleView as! UISegmentedControl
  }

  init(urlProvider: @escaping URLProvider) {
    self.urlProvider = urlProvider

    super.init(nibName: nil, bundle: nil)

    self.title = "Swift Checkout"
  }

  private enum Language: Int, CaseIterable {
    case swift, objc

    var title: String {
      switch self {
      case .swift: return "Swift"
      case .objc: return "Objc"
      }
    }
  }

  override func loadView() {
    view = CheckoutView()
    navigationItem.titleView = UISegmentedControl(
      items: Language.allCases.map(\.title)
    )
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    segmentedControl.selectedSegmentIndex = Language.swift.rawValue
    checkoutView.payButton.addTarget(self, action: #selector(didTapPay), for: .touchUpInside)
  }

  // MARK: Checkout

  @objc private func didTapPay() {
    let successHandler = { [unowned self] token in
      self.show(MessageViewController(message: token), sender: self)
    }

    let completion = { (result: CheckoutResult) in
      switch result {
      case .success(let token): successHandler(token)
      case .cancelled: break
      }
    }

    let presentCheckout = { [unowned self] (checkoutUrl: URL) in
      let language = Language(rawValue: self.segmentedControl.selectedSegmentIndex)

      switch language {
      case .swift:
        Afterpay.presentCheckoutModally(over: self, loading: checkoutUrl, completion: completion)

      case .objc:
        Objc.presentCheckoutModally(over: self, loading: checkoutUrl, successHandler: successHandler)

      default:
        break
      }
    }

    let presentError = { [unowned self] (error: Error) in
      let alert = AlertFactory.alert(for: error)
      self.present(alert, animated: true, completion: nil)
    }

    urlProvider { result in
      let action: () -> Void

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
