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

  func afterpayCheckout(
    checkoutURL: Binding<URL?>,
    completion: @escaping (_ result: CheckoutResult) -> Void
  ) -> some View {
    let itemBinding: Binding<URLItem?> = Binding(
      get: { checkoutURL.wrappedValue.flatMap(URLItem.init) },
      set: { checkoutURL.wrappedValue = $0?.id }
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

  func makeUIViewController(context: Context) -> WebViewController {
    WebViewController(checkoutUrl: checkoutURL, completion: completion)
  }

  func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
    // SwiftUI inserts a UIHostingController around the SwiftUIWrapper View, we need to ensure that
    // we become the delegate of the correct presentation controller
    let topmostViewController = uiViewController.parent ?? uiViewController
    topmostViewController.presentationController?.delegate = uiViewController
  }

}
