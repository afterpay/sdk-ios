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
struct PurchaseView: View {
  @State private var checkoutURL: URL?

  var body: some View {
    NavigationView {
      VStack {
        Text("Welcome to the Afterpay SDK")
        Button("Checkout") {
          checkout(with: Settings.email, for: "30.00") { result in
            switch result {
            case .success(let url):
              DispatchQueue.main.async { self.checkoutURL = url }
            case .failure:
              break
            }
          }
        }
      }
      .navigationBarTitle("Aftersnack")
      .afterpayCheckout(checkoutURL: $checkoutURL) { result in
        switch result {
        case .success(let token):
          print("Afterpay payment success with token: \(token)")
        case .cancelled:
          print("Afterpay payment cancelled")
        }
      }
    }
  }
}

@available(iOS 13.0.0, *)
struct PurchaseView_Previews: PreviewProvider {
  static var previews: some View {
    PurchaseView()
  }
}
