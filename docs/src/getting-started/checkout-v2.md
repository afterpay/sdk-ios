---
layout: default
title: Checkout V2
parent: Getting Started
nav_order: 3
---

# Checkout V2
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

Checkout version 2 allows you to load the checkout token on demand via `didCommenceCheckout` while presenting a loading view. It also supports `express` checkout features and callbacks which can either be handled in line or via a checkout handler object.

{: .note }
> Two requirements must be met in order to use checkout v2 successfully:
> - Configuration must always be set before presentation otherwise you will incur an assertionFailure.
> - When creating a checkout token `popupOriginUrl` must be set to `https://static.afterpay.com`. The SDK’s example merchant server sets the parameter [here][example-server-param]{:target="_blank"}. See more at by checking the [api reference][express-checkout]{:target="_blank"}. Failing to do so will cause undefined behavior.

The following examples are in Swift and UIKit. Objective-C and SwiftUI wrappers have not been provided at this time for v2. Please raise an issue if you would like to see them implemented.

## Debugging

Known checkout related errors that are handled within the web implementation of checkout are logged using `os_log` using the `debug` log type for use when debugging.

## Swift (UIKit)

A standard checkout implemented with v2 loads the token on demand.

```swift
Afterpay.presentCheckoutV2Modally(
  over: viewController,
  didCommenceCheckout: { completion in
    // Load the token passing the result to completion
  },
  completion: { result in
    switch result {
    case .success(let token):
      // Handle successful Afterpay checkout
    case .cancelled(let reason):
      // Handle checkout cancellation
    }
  }
)
```

An express checkout can make use of callbacks and options to provide a richer checkout experience. For more information on express checkout please check the [API reference][express-checkout]{:target="_blank"}.

```swift
Afterpay.presentCheckoutV2Modally(
  over: viewController,
  options: CheckoutV2Options(buyNow: true),
  didCommenceCheckout: { completion in
    // Load the token passing the result to completion
  },
  shippingAddressDidChange: { address, completion in
    // Use the address to form a shipping options result and pass to completion
  },
  shippingOptionDidChange: { shippingOption, completion in
    // Optionally update your application model with the selected shipping option
    // To update the shipping method, pass in a shippingOptionUpdate object to
    // completion, otherwise pass nil
  },
  completion: { result in
    switch result {
    case .success(let token):
      // Handle successful Afterpay checkout
    case .cancelled(let reason):
      // Handle checkout cancellation
    }
  }
)
```

If you wish to handle these callbacks separately to presentation you can do so by implementing a handler object.

```swift
final class CheckoutHandler: CheckoutV2Handler {
  func didCommenceCheckout(completion: @escaping CheckoutTokenResultCompletion) {
    // Load the token passing the result to completion
  }

  func shippingAddressDidChange(address: ShippingAddress, completion: @escaping ShippingOptionsCompletion) {
    // Use the address to form a shipping options result and pass to completion
  }

  func shippingOptionDidChange(shippingOption: ShippingOption, completion: @escaping ShippingOptionCompletion) {
    // Optionally update your application model with the selected shipping option
  }
}

final class MyViewController: UIViewController {
  // You must maintain a reference to your handler as it is stored as a weak reference within the SDK
  private let handler = CheckoutHandler()
  // ...
  override func viewDidLoad() {
    super.viewDidLoad()

    Afterpay.setCheckoutV2Handler(handler)
  }
  // ...
  @objc func didTapPayWithAfterpay() {
    Afterpay.presentCheckoutV2Modally(over: viewController) { result in
      switch result {
      case .success(let token):
        // Handle successful Afterpay checkout
      case .cancelled(let reason):
        // Handle checkout cancellation
      }
    }
  }
}
```

## Sequence Diagram

The below diagram describes the happy path.

``` mermaid
sequenceDiagram
  participant App
  participant Afterpay SDK
  participant Proxy Server
  participant Afterpay API

  Note over App,Afterpay API: Setup

  App->>Afterpay SDK: Configure the SDK

  App->>Afterpay SDK: Setup checkout handlers

  Note over App,Afterpay API: Create checkout and Capture

  App->>Proxy Server: Get Checkout Token Request

  Proxy Server->>Afterpay API: Create Checkout Request
  Note over Proxy Server,Afterpay API: Ensure same environment<br>as Afterpay SDK config

  Afterpay API-->>Proxy Server: Create Checkout Response
  Note over Afterpay API,Proxy Server: Body contains a Token

  Proxy Server-->>App: Get Token Response

  App->>Afterpay SDK: Launch the checkout<br>with the Token

  Note over App,Afterpay API: Consumer confirms Afterpay checkout

  Afterpay SDK-->>App: Checkout result

  App->>Proxy Server: Capture request

  Proxy Server->>Afterpay API: Capture request

  Afterpay API-->>Proxy Server: Capture response

  Proxy Server-->>App: Capture Response

  App->>App: Handle response
```

[example-server-param]: https://github.com/afterpay/sdk-example-server/blob/5781eadb25d7f5c5d872e754fdbb7214a8068008/src/routes/checkout.ts#L28
[express-checkout]: https://developers.afterpay.com/afterpay-online/reference#what-is-express-checkout
