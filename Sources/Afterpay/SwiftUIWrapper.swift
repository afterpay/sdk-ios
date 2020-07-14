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

  func afterpayCheckoutSheet(isPresented: Binding<Bool>) -> some View {
    sheet(isPresented: isPresented) {
      SwiftUIWrapper()
    }
  }

}

struct SwiftUIWrapper: UIViewControllerRepresentable {
  typealias UIViewControllerType = WebViewController

  func makeUIViewController(context: Context) -> WebViewController {
    WebViewController(
      checkoutUrl: URL(string: "google.com")!,
      completion: { _ in }
    )
  }

  func updateUIViewController(_ uiViewController: WebViewController, context: Context) {
  }
}
