//
//  PurchaseView.swift
//  Example
//
//  Created by Adam Campbell on 14/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Foundation
import SwiftUI

@available(iOS 13.0, *)
private typealias Environment = SwiftUI.Environment

@available(iOS 13.0, *)
struct SwiftUIExampleView: View {

  @State private var checkoutURL: URL?

  let checkoutResultHandler: (CheckoutResult) -> Void = { result in
    switch result {
    case .success(let token):
      print("Afterpay payment success with token: \(token)")
    case .cancelled:
      print("Afterpay payment cancelled")
    }
  }

  var body: some View {
    NavigationView {
      CheckoutView(urlBinding: $checkoutURL)
        .navigationBarTitle("Aftersnack")
        .afterpayCheckout(url: $checkoutURL, completion: checkoutResultHandler)
    }
  }

}

@available(iOS 13.0.0, *)
private struct CheckoutView: View {

  @Environment(\.repository) private var repository

  let checkoutResultHandler: (Result<CheckoutsResponse, Error>) -> Void

  init(urlBinding: Binding<URL?>) {
    checkoutResultHandler = { result in
      switch result {
      case .success(let response):
        DispatchQueue.main.async { urlBinding.wrappedValue = response.url }
      case .failure:
        break
      }
    }
  }

  var body: some View {
    VStack {
      Text("Welcome to the Afterpay SDK")
      Button("Checkout") {
        self.repository.checkout(
          email: Settings.email,
          amount: "30.00",
          checkoutMode: .v1,
          isCashApp: false,
          completion: self.checkoutResultHandler
        )
      }
    }
  }

}

@available(iOS 13.0.0, *)
struct PurchaseView_Previews: PreviewProvider {
  static var previews: some View {
    SwiftUIExampleView()
  }
}
