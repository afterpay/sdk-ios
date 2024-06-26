---
layout: default
title: Checkout V1
parent: Getting Started
nav_order: 2
---

# Checkout V1
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

Checkout version 1 requires you to manage the loading of a checkout URL yourself and provide it to the SDK. This version of checkout only supports `standard` mode and completes on receiving a redirect.

The Web Login is a `UIViewController` that can be presented modally over the view controller of your choosing.

{: .note }
> When creating a checkout token, both `redirectConfirmUrl` and `redirectCancelUrl` must be set. Failing to do so will cause undefined behavior. The SDK’s example merchant server sets the parameters [here](https://github.com/afterpay/sdk-example-server/blob/5781eadb25d7f5c5d872e754fdbb7214a8068008/src/routes/checkout.ts#L26-L27). See more by checking the [api reference](https://developers.afterpay.com/afterpay-online/reference/javascript-afterpayjs#redirect-method).
>
> By default the SDK *will not* load these redirect URLs when the checkout is confirmed or cancelled, but will allow the result to be handled as seen in the example below. If it is required that these URLs be loaded, the `shouldLoadRedirectUrls` parameter can be set to `true` on the `presentCheckoutModally` method.

### Swift (UIKit)

```swift
import Afterpay
import UIKit

final class CheckoutViewController: UIViewController {
  // ...
  @objc func didTapPayWithAfterpay() {
    /**
     * `presentCheckoutModally` can take a `shouldLoadRedirectUrls` which is
     * a boolean for whether the redirect urls set when generating
     * the checkout url should load. Default and recommended value is false
     */
    Afterpay.presentCheckoutModally(over: self, loading: self.checkoutUrl) { result in
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

### Objective-C (UIKit)

```objc
#import "ViewController.h"
#import <Afterpay/Afterpay-Swift.h>
#import <UIKit/UIKit.h>

@implementation ViewController

// ...

- (void)didTapPayWithAfterpay {

  void (^completion)(APCheckoutResult *) = ^(APCheckoutResult *result) {

    if ([result isKindOfClass:[APCheckoutResultSuccess class]]) {
      // Handle success with [(APCheckoutResultSuccess *)result token]
    } else {
      // Handle cancellation with [(APCheckoutResultCancelled *)result reason]
    }

  };

  [APAfterpay presentCheckoutModallyOverViewController:self
                                    loadingCheckoutURL:self.checkoutUrl
                                              animated:true
                                            completion:completion];

}

@end
```

### SwiftUI

```swift
struct MyView: View {

  // Updating this state with a retrieved checkout URL will present the afterpay sheet
  @State private var checkoutURL: URL?

  var body: some View {
    SomeView()
      .afterpayCheckout(url: $checkoutURL) { result in
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
  Note over App,Afterpay SDK: Only required if<br>setting consumer locale

  Note over App,Afterpay API: Create checkout and Capture

  App->>Proxy Server: Get Checkout URL Request

  Proxy Server->>Afterpay API: Create Checkout Request
  Note over Proxy Server,Afterpay API: Ensure same environment<br>as Afterpay SDK config

  Afterpay API-->>Proxy Server: Create Checkout Response
  Note over Afterpay API,Proxy Server: Body contains a URL

  Proxy Server-->>App: Get URL Response

  App->>Afterpay SDK: Launch the checkout<br>with the URL

  Note over App,Afterpay API: Consumer confirms Afterpay checkout

  Afterpay SDK-->>App: Checkout result

  App->>Proxy Server: Capture request

  Proxy Server->>Afterpay API: Capture request

  Afterpay API-->>Proxy Server: Capture response

  Proxy Server-->>App: Capture Response

  App->>App: Handle response
```
