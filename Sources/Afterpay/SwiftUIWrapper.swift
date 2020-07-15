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

public struct CheckoutURL: Identifiable {

  public var id: URL { url }

  public let url: URL

  public init(url: URL) {
    self.url = url
  }

}

@available(iOS 13.0, *)
public extension View {

  func afterpayCheckout(checkoutURL: Binding<CheckoutURL?>) -> some View {
    // Make a new binding from a URL binding

    sheet(item: checkoutURL) { checkoutURL -> SwiftUIWrapper in
      SwiftUIWrapper(checkoutURL: checkoutURL.url)
    }
  }

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
