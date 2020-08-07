//
//  SwiftUIWrapper.swift
//  Afterpay
//
//  Created by Adam Campbell on 14/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit

@available(iOS 13.0, *)
public extension View {

  /// Presents Afterpay Checkout in a web view as a sheet using the provided checkout URL as a data
  /// source for the loaded web content.
  /// - Parameters:
  ///   - url: A binding to an optional source of truth for the loaded web content. This should be
  ///   an Afterpay Checkout URL produced from the /checkouts endpoint. When a non nil URL is set,
  ///   a checkout sheet is presented. If the URL changes a new sheet is presented. If nil is set
  ///   the sheet is dismissed.
  ///   - completion: Called with the result of a checkout after dismissal.
  func afterpayCheckout(
    url: Binding<URL?>,
    completion: @escaping (_ result: CheckoutResult) -> Void
  ) -> some View {
    let itemBinding: Binding<URLItem?> = Binding(
      get: { url.wrappedValue.map(URLItem.init) },
      set: { url.wrappedValue = $0?.id }
    )

    return sheet(item: itemBinding) { item -> SwiftUIWrapper in
      SwiftUIWrapper(checkoutURL: item.id, completion: completion)
    }
  }

}

struct URLItem: Identifiable {

  let id: URL

}

struct SwiftUIWrapper: UIViewControllerRepresentable {

  let checkoutURL: URL
  let completion: (_ result: CheckoutResult) -> Void

  func makeUIViewController(context: Context) -> CheckoutWebViewController {
    CheckoutWebViewController(checkoutUrl: checkoutURL, completion: completion)
  }

  func updateUIViewController(_ uiViewController: CheckoutWebViewController, context: Context) {
    // SwiftUI inserts a UIHostingController around the SwiftUIWrapper View, we need to ensure that
    // we become the delegate of the correct presentation controller
    let topmostViewController = uiViewController.parent ?? uiViewController
    topmostViewController.presentationController?.delegate = uiViewController
  }

}
