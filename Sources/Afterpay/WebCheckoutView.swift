//
//  WebCheckoutView.swift
//  Afterpay
//
//  Created by Ryan Davis on 3/7/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import SwiftUI
import WebKit

@available(iOS 13.0.0, *)
public struct AfterpayWebCheckout: View {
  private let checkoutUrl: URL
  private let completion: (_ result: CheckoutResult) -> Void

  @State private var promptToDismiss: Bool = false
  @Environment(\.presentationMode) private var presentationMode

  public init(checkoutUrl: URL, completion: @escaping (_ result: CheckoutResult) -> Void) {
    self.checkoutUrl = checkoutUrl
    self.completion = completion
  }

  public var body: some View {
    NavigationView {
      WebViewWrapper(checkoutUrl: checkoutUrl) { result in
        self.completion(result)
        self.presentationMode.wrappedValue.dismiss()
      }
        .navigationBarTitle("", displayMode: .inline)
        .navigationBarItems(
          trailing: Button("Close") {
            self.promptToDismiss = true
          }
        )
    }
      .captureDismiss {
        self.promptToDismiss = true
      }
      .actionSheet(isPresented: $promptToDismiss) {
        ActionSheet(
          title: Text("Are you sure you want to cancel the payment?"),
          buttons: [
            .destructive(Text("Yes")) {
              self.completion(.cancelled)
              self.presentationMode.wrappedValue.dismiss()
            },
            .cancel(Text("No")) {
              self.promptToDismiss = false
            },
          ]
        )
      }
      .edgesIgnoringSafeArea(.bottom)
  }
}

@available(iOS 13.0.0, *)
private final class WebViewWrapper: UIViewRepresentable {
  private let checkoutUrl: URL
  private let completion: (_ result: CheckoutResult) -> Void

  init(checkoutUrl: URL, completion: @escaping (_ result: CheckoutResult) -> Void) {
    self.checkoutUrl = checkoutUrl
    self.completion = completion
  }

  func makeUIView(context: Context) -> WKWebView {
    let webView = WKWebView()
    webView.allowsLinkPreview = false
    webView.navigationDelegate = context.coordinator
    webView.load(URLRequest(url: checkoutUrl))
    return webView
  }

  func updateUIView(_ webView: WKWebView, context: Context) {}

  func makeCoordinator() -> WebViewDelegate {
    WebViewDelegate(completion: completion)
  }
}

@available(iOS 13.0, *)
private struct CaptureDismissView<Content: View>: UIViewControllerRepresentable {
  let contentView: Content
  let onDismissAttempt: () -> Void

  init(contentView: Content, onDismissAttempt: @escaping () -> Void) {
    self.contentView = contentView
    self.onDismissAttempt = onDismissAttempt
  }

  func makeUIViewController(context: Context) -> UIHostingController<Content> {
    UIHostingController(rootView: contentView)
  }

  func updateUIViewController(_ uiViewController: UIHostingController<Content>, context: Context) {
    uiViewController.parent?.presentationController?.delegate = context.coordinator
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(onDismissAttempt: onDismissAttempt)
  }

  class Coordinator: NSObject, UIAdaptivePresentationControllerDelegate {
    private let onDismissAttempt: () -> Void

    init(onDismissAttempt: @escaping () -> Void) {
      self.onDismissAttempt = onDismissAttempt
    }

    func presentationControllerShouldDismiss(_ presentationController: UIPresentationController) -> Bool {
      false
    }

    func presentationControllerDidAttemptToDismiss(_ presentationController: UIPresentationController) {
      onDismissAttempt()
    }
  }
}

@available(iOS 13.0, *)
private extension View {
  func captureDismiss(action: @escaping () -> Void) -> some View {
    CaptureDismissView(contentView: self, onDismissAttempt: action)
  }
}
