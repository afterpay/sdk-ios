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

  func afterpayCheckout(checkoutURL: Binding<URL?>) -> some View {
    let itemBinding: Binding<URLItem?> = Binding(
      get: { checkoutURL.wrappedValue.flatMap(URLItem.init) },
      set: { checkoutURL.wrappedValue = $0?.id }
    )

    return sheet(item: itemBinding) { item -> SwiftUIWrapper in
      SwiftUIWrapper(checkoutURL: item.id)
    }
  }

}

struct URLItem: Identifiable {
  let id: URL
}

struct SwiftUIWrapper: UIViewControllerRepresentable {

  let checkoutURL: URL

  func makeUIViewController(context: Context) -> WebViewController {
    WebViewController(checkoutUrl: checkoutURL, completion: { _ in })
  }

  func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
    // SwiftUI can insert a hosting controller around
    let topmostViewController = uiViewController.parent ?? uiViewController
    topmostViewController.presentationController?.delegate = uiViewController
  }

}
