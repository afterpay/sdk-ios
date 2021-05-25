# Afterpay iOS SDK

![Build and Test][badge-ci]
[![Swift Package Manager compatible][badge-spm]][spm]
[![Carthage compatible][badge-carthage]][carthage]
[![CocoaPods compatible][badge-ccp]][ccp]
![Platform][badge-platform]
![License][badge-license]

The Afterpay iOS SDK provides conveniences to make your Afterpay integration experience as smooth and straightforward as possible. We're working on crafting a great framework for developers with easy drop in components to make payments easy for your customers.

# Table of Contents

- [Afterpay iOS SDK](#afterpay-ios-sdk)
- [Table of Contents](#table-of-contents)
- [Integration](#integration)
  - [Requirements](#requirements)
  - [Swift Package Manager](#swift-package-manager-recommended)
  - [Carthage](#carthage)
  - [CocoaPods](#cocoapods)
  - [Manual](#manual)
    - [Source](#source)
      - [GitHub Release](#github-release)
      - [Git Submodule](#git-submodule)
      - [Project / Workspace Integration](#project--workspace-integration)
- [Features](#features)
  - [Web Checkout](#web-checkout)
    - [Checkout v1](#checkout-v1)
    - [Checkout v2](#checkout-v2)
    - [Clearpay Checkout](#clearpay-checkout)
    - [Clearing Cookies](#clearing-cookies)
  - [Widget](#widget)
  - [Security](#security)
    - [Swift](#swift)
    - [Objective-C](#objective-c)
  - [Views](#views)
    - [Color Schemes](#color-schemes)
    - [Badge](#badge)
    - [Payment Button](#payment-button)
  - [Price Breakdown](#price-breakdown)
    - [Accessibility and Dark mode](#accessibility-and-dark-mode)
- [Getting Started](#getting-started)
  - [Presenting Web Checkout v1](#presenting-web-checkout-v1)
    - [Swift (UIKit)](#swift-uikit)
    - [Objective-C (UIKit)](#objective-c-uikit)
    - [SwiftUI](#swiftui)
  - [Configuration](#configuration)
  - [Presenting Web Checkout v2](#presenting-web-checkout-v2)
    - [Debugging](#debugging)
    - [Swift (UIKit)](#swift-uikit-1)
  - [Presenting the Widget](#presenting-the-widget)
    - [With Checkout Token](#with-checkout-token)
    - [Tokenless](#tokenless)
    - [Widget Options](#widget-options)
    - [Updating the Widget](#updating-the-widget)
    - [Getting the Widget Status](#getting-the-widget-status)
    - [Widget Handler](#widget-handler)
- [Examples](#examples)
- [Building](#building)
  - [Mint](#mint)
  - [Running](#running)
- [Contributing](#contributing)
- [License](#license)

# Integration

## Requirements

- iOS 12.0+
- Swift 5.3+
- Xcode 12.0+

## Swift Package Manager (recommended)

This is the recommended integration method.

```
dependencies: [
    .package(url: "https://github.com/afterpay/sdk-ios.git", .upToNextMajor(from: "3.0.0"))
]
```

## Carthage

```
github "afterpay/sdk-ios" ~> 3.0
```

## CocoaPods

```
pod 'Afterpay', '~> 3.0'
```

## Manual

If you prefer not to use any of the supported dependency managers, you can choose to manually integrate the Afterpay SDK into your project.

### Source

#### GitHub Release

Download the [latest release][latest-release] source zip from GitHub and unzip into an `Afterpay` directory in the root of your working directory.

#### Git Submodule

Add the Afterpay SDK as a [git submodule][git-submodule] by navigating to the root of your working directory and running the following commands:

```
git submodule add https://github.com/afterpay/sdk-ios.git Afterpay
cd Afterpay
git checkout 3.0.0
```

#### Project / Workspace Integration

Now that the Afterpay SDK resides in the `Afterpay` directory in the root of your working directory, it can be added to your project or workspace with the following steps:

1. Open the new `Afterpay` directory, and drag `Afterpay.xcodeproj` into the Project Navigator of your application's Xcode project or workspace.
2. Select your application project in the Project Navigator to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
3. In the tab bar at the top of that window, open the "General" panel.
4. Click on the `+` button under the "Frameworks, Libraries, and Embedded Content" section.
5. Select the `Afterpay.framework` for your target platform.

And that's it, the Afterpay SDK is now ready to import and use within your application.

# Features

The Afterpay SDK contains a checkout web flow with optional security features as well some UI components.

There is also a price-breakdown 'checkout widget'. It mirrors the functionality of the web checkout widget. (Note: this is not a iOS home screen widget.)

## Web Checkout

Provided the URL or token generated during the checkout process we take care of pre approval process during which the user will log into Afterpay. The provided integration makes use of cookie storage such that returning customers will only have to re-authenticate with Afterpay once their existing sessions have expired. There are currently two versions of web checkout.

### Checkout v1

```swift
Afterpay.presentCheckoutModally(over:loading:animated:completion:)
```

Checkout version 1 requires you to manage the loading of a checkout URL yourself and provide it to the SDK. This version of checkout only supports `standard` mode and completes on receiving a redirect.

### Checkout v2

```swift
Afterpay.presentCheckoutV2Modally(over:animated:options:didCommenceCheckout:shippingAddressDidChange:shippingOptionDidChange:completion:)
```

Checkout version 2 allows you to load the checkout token on demand via `didCommenceCheckout` while presenting a loading view. It also supports `express` checkout features and callbacks which can either be handled in line or via a checkout handler object.

The configuration object *must* be set before calling checkout v2.

### Clearpay Checkout

Checkout supports Clearpay for v1 this means supplying a correctly formed URL for the Clearpay environment with a token created for a Clearpay checkout. For v2 this means loading a Clearpay token on demand as well as ensuring to set the locale as `en_GB` in Afterpay configuration.

### Clearing Cookies

Cookies are stored in the default WebKit website data store and can be cleared if required by writing code similar to:

```swift
let dataStore = WKWebsiteDataStore.default()
let dataTypes = [WKWebsiteDataTypeCookies] as Set<String>

dataStore.fetchDataRecords(ofTypes: dataTypes) { records in
  let afterpayRecords = records.filter { $0.displayName == "afterpay.com" }
  dataStore.removeData(ofTypes: dataTypes, for: afterpayRecords) {}
}
```

## Widget

The checkout widget displays the consumer's payment schedule, and can be updated as the order total changes. It should be shown if the order value is going to change after the Afterpay Express checkout has finished. For example, the order total may change in response to shipping costs and promo codes. It can also be used to show if there are any barriers to completing the purchase, like if the customer has gone over their Afterpay payment limit.

It can be used in two ways: with a checkout token (from checkout v2) or with a monetary amount (also known as 'tokenless mode'). 

```swift
// With token:
WidgetView.init(token:)

// Without token:
WidgetView.init(amount:)
```

An example 'tokenless' widget, with four payments of $50 adding to $200:
<img src="https://github.com/afterpay/sdk-ios/blob/huwr/readme/Images/widget.png" width=50% height=50%>

## Security

For added security, a method to hook into the SDKs WKWebView Authentication Challenge Handler is provided. With this you can implement things like SSL Pinning to ensure you can trust your end to end connections. An example of this has been provided in the [example project][example] and in the snippet below using [TrustKit][trust-kit]. In this handler you must return whether or not you have handled the challenge yourself (have called the completionHandler) by returning `true`, or if you wish to fall back to the default handling by returning `false`.

This technique is supported on both the checkout versions, and the widget.

### Swift

```swift
Afterpay.setAuthenticationChallengeHandler { challenge, completionHandler -> Bool in
 let validator = TrustKit.sharedInstance().pinningValidator
 return validator.handle(challenge, completionHandler: completionHandler)
}
```

### Objective-C

```objc
typedef void (^ CompletionHandler)(NSURLSessionAuthChallengeDisposition, NSURLCredential *);

BOOL (^challengeHandler)(NSURLAuthenticationChallenge *, CompletionHandler) = ^BOOL(
 NSURLAuthenticationChallenge *challenge,
 CompletionHandler completionHandler
) {
 TSKPinningValidator *pinningValidator = [[TrustKit sharedInstance] pinningValidator];
 return [pinningValidator handleChallenge:challenge completionHandler:completionHandler];
};

[APAfterpay setAuthenticationChallengeHandler:challengeHandler];
```

## Views

### Color Schemes

Color schemes can be set on the badge view or payment button to either have a single style in both light and dark mode or to change automatically.

```swift
// Always black on mint
badgeView.colorScheme = .static(.blackOnMint)

// White on black in light mode and black on white in dark mode
badgeView.colorScheme = .dynamic(lightPalette: .whiteOnBlack, darkPalette: .blackOnWhite)
```

### Badge

The Afterpay badge is a simple `UIView` that can be scaled to suit the needs of your app. As per branding guidelines it has a minimum width constraint of 64 points.

```swift
let badgeView = BadgeView()
```

Below are examples of the badge in each of the color schemes:  
![Black on Mint badge][badge-black-on-mint] ![Mint on Black badge][badge-mint-on-black] ![White on Black badge][badge-white-on-black] ![Black on White badge][badge-black-on-white]

### Payment Button

The Afterpay `PaymentButton` is a subclass of `UIButton` that can be scaled to suit your layout, to guarantee legibility it has a maximum width constraint of 256 points.

Below are examples of the button in each of the color schemes:
| Mint and Black | Black and White |
| -- | -- |
| ![Black on Mint button][button-black-on-mint] | ![White on Black button][button-white-on-black] | 
| ![Mint on Black button][button-mint-on-black] | ![Black on White button][button-black-on-white] |

There are also a few other kinds of payment available, with different wording:

* Buy Now
* Checkout
* Pay Now
* Place Order

Using a `PaymentButton` is easy. Configure it with some parameters sent to its initialiser. These parameters are optional, however.

```swift
let payButton = PaymentButton(colorScheme: .dynamic(lightPalette: .blackOnMint, darkPalette: .mintOnBlack), buttonKind: .checkout)
```

## Price Breakdown

The price breakdown component displays information about Afterpay instalments and handles a number of common scenarios.

A configuration should be set on the Afterpay SDK in line with configuration data retrieved from the Afterpay API. This configuration can be cached and should be updated once per day.

A locale should also be set matching the region for which you need to display terms and conditions. This also affects how currencies are localised as well as what branding is displayed, for instance usage of the `"en_GB"` locale will display Clearpay branding.

```swift
do {
  let configuration = try Configuration(
    minimumAmount: response.minimumAmount?.amount,
    maximumAmount: response.maximumAmount.amount,
    currencyCode: response.maximumAmount.currency,
    locale: Locale(identifier: "en_US")
  )

  Afterpay.setConfiguration(configuration)
} catch {
  // Something went wrong
}
```

A total payment amount (represented as a Swift Decimal) must be programatically set on the component to display Afterpay instalment information.

```swift
// A zero here will display the generic 'pay with afterpay' messaging
let totalAmount = Decimal(string: price) ?? .zero

let priceBreakdownView = PriceBreakdownView()
priceBreakdownView.totalAmount = totalAmount
```

After setting the total amount the matching breakdown string for the set Afterpay configuration will be displayed.

For example:  
![Four payments available][four-payments]

### Accessibility and Dark mode

By default this component updates when the trait collection changes to update text and image size as well as colors to match. A components page in the Example app has been provided to demonstrate.

# Getting Started

We provide options for integrating the SDK in Swift and Objective-C.

## Presenting Web Checkout v1

The Web Login is a `UIViewController` that can be presented modally over the view controller of your choosing.

### Swift (UIKit)

```swift
import Afterpay
import UIKit

final class CheckoutViewController: UIViewController {
  // ...
  @objc func didTapPayWithAfterpay() {
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

## Configuration

For version 2 of Checkout a configuration is required to determine the endpoint and environment. Your configuration should be formed from the configuration API as well as the localization settings of your store. The `locale` determines the endpoint checkout v2 will use, for locales with a `US` region the US checkout URL will be used for instance. For environment we recommend using `.sandbox` in debug and `.production` for release builds.

For example:
```swift
let configuration = try Configuration(
  minimumAmount: response.minimumAmount?.amount,
  maximumAmount: response.maximumAmount.amount,
  currencyCode: response.maximumAmount.currency,
  locale: Locale(identifier: "en_US"),
  environment: .sandbox
)

Afterpay.setConfiguration(configuration)
```

You may also choose to send the desired locale and/or environment data back from your own API. This configuration should be cached by your application and an attempt to update it should be made once a day (or a frequency you determine acceptable based on your requirements). It is also recommended to include an initial version matching the live configuration in case the first time load fails.

## Presenting Web Checkout v2

The following examples are in Swift and UIKit. Objective-C and SwiftUI wrappers have not been provided at this time for v2. Please raise an issue if you would like to see them implemented.

> **NOTE:** 
> Two requirements must be met in order to use checkout v2 successfully:
> - Configuration must always be set before presentation otherwise you will incur an assertionFailure.
> - When creating a checkout token `popupOriginUrl` must be set to `https://static.afterpay.com`. See more at by checking the [api reference][express-checkout]. Failing to do so will cause undefined behavior.

### Debugging

Known checkout related errors that are handled within the web implementation of checkout are logged using `os_log` using the `debug` log type for use when debugging.

### Swift (UIKit)

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

An express checkout can make use of callbacks and options to provide a richer checkout experience. For more information on express checkout please check the [API reference][express-checkout]

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
  shippingOptionDidChange: { shippingOption in
    // Optionally update your application model with the selected shipping option
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

  func shippingAddressDidChange(address: Address, completion: @escaping ShippingOptionsCompletion) {
    // Use the address to form a shipping options result and pass to completion
  }

  func shippingOptionDidChange(shippingOption: ShippingOption) {
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

## Presenting The Widget

The checkout widget is available via `WidgetView`, which is a `UIView` subclass. There are two initialisers. Which one you'll use depends on if you are showing the widget before or after a checkout.

Internally, the web widget is rendered in `WKWebView` subview. It has an [intrinsic content size](https://developer.apple.com/library/archive/documentation/UserExperience/Conceptual/AutolayoutPG/AnatomyofaConstraint.html#//apple_ref/doc/uid/TP40010853-CH9-SW21) which changes to fit the web widget. The `WidgetView` matches its intrinsic content height to the internal web widget's height. The web widget is responsive and will fit any container with a minimum width of 300 pixels.

### With Checkout Token

Use this mode after completing a checkout using the [v2 Checkout](#checkout-v2) feature. Take the token from the checkout's result and provide it to this initialiser. The widget will use the token to look up information about the transaction and display it.

```swift
WidgetView.init(token:)
```

### Tokenless

Use this mode if you want a `WidgetView`, but have not yet been through an Afterpay checkout. The `amount` parameter is the order total. It must be in the same currency that was sent to `Afterpay.setConfiguration`.  The configuration object *must* be set before initialising a tokenless widget.

```swift
WidgetView.init(amount:)
```

### Widget Options

The widget has appearance options. You can provide these when you initialise the `WidgetView`. 

Both initialisers take an optional second parameter: a `WidgetView.Style`. The style type contains the appearance options for the widget. At the moment, the only options for `Style` are booleans for the `logo` and the `header`. By default, they are `true`.

```swift
WidgetView.init(amount: amount, style: WidgetView.Style(logo: false, heading: false))
```

#### The `WidgetView`'s border

Additionally, the `WidgetView` has a border and rounded corners. These are set on the `WidgetView`'s layer. You can adjust them, too, to fit in with your app's design:

```swift
// make rounded corners less round
widgetView.layer.cornerRadius = 4

// change the color of the border
widgetView.layer.borderColor = UIColor.someOtherColor
```

### Updating the Widget

The order total will change due to circumstances like promo codes, shipping options, _et cetera_. When the it has changed, you should inform the widget so that it can update what it is displaying. 

You may send updates to the widget via its `sendUpdate(amount:)` function. The `amount` parameter is the total amount of the order. It must be in the same currency that was sent to `Afterpay.setConfiguration`.  The configuration object *must* be set before calling this method, or it will throw.

```swift
widgetView.sendUpdate(amount: "50.00") // set the widget's amount to 50
```

### Getting the Widget Status

You can also enquire about the current status of the widget. This is an asynchronous call because there may be a short delay before the web-backed widget responds. The completion handler is always called on the main thread.

(If you wish to be informed when the status has changed, consider setting a `WidgetHandler`)

```swift
widgetView.getStatus { result in 
  // handle result
}
```

The `result` returned, if successful, is a `WidgetStatus`. This tells you if the widget is either in a valid or invalid state. `WidgetStatus` is an enum with two cases: `valid` and `invalid`. Each case has associated values appropriate for their circumstances. 

`valid` has the amount of money due today and the payment schedule checksum. The checksum is a unique value representing the payment schedule that must be provided when capturing the order. `invalid` has the error code and error message. The error code and message are optional.

### Widget Handler

If you wish to be informed when the status has changed, set up a `WidgetHandler`. `WidgetHandler` is protocol you can implement, and then provide your implementation to the Afterpay SDK with `Afterpay.setWidgetHandler`. The SDK will call your implementation when an event occurs.

For example:

```swift
final class ExampleWidgetHandler: WidgetHandler {

  func onReady(isValid: Bool, amountDueToday: Money, paymentScheduleChecksum: String?) {
    // The widget ready to accept updates
  }

  func onChanged(status: WidgetStatus) {
    // The widget has had an update. 
  }

  func onError(errorCode: String?, message: String?) {
    // The widget has had an error
  }

  func onFailure(error: Error) {
    // An internal error has occurred inside the SDK
  }

}

final class MyViewController: UIViewController {

  let widgetHandler: WidgetHandler = ExampleWidgetHandler()

  init() {
    // ... snip ...
  
    // Do this some time before displaying the widget. Doesn't have to be in init()
    Afterpay.setWidgetHandler(widgetHandler)
  }

}
```

See the `WidgetHandler` protocol for a more detailed description of what gets called when and with what.

For iOS 13 or above, we provide a `WidgetEventPublisher`. It provides Combine `Publisher`s for the `WidgetHandler` events:

```swift
let eventPublisher = WidgetEventPublisher()

eventPublisher.changed
  .sink(receiveValue: { status in /* respond to status */ })
  .store(in: &cancellables)
```

# Examples

The [example project][example] demonstrates how to include an Afterpay payment flow web experience. This project is powered by the [example server][example-server] which shows a simple example of integration with the Afterpay API.

# Building

## Mint

The Afterpay SDK uses [Mint][mint] to install and run Swift command line packages. This has been pre-compiled and included in the repository under the [`Tools/mint`][mint-directory] directory, meaning it does not need to be installed or managed externally.

> **NOTE:** Mint will automatically download the packages it manages on demand. To speed up the initial build of the SDK, the packages can be downloaded by running the [`Scripts/bootstrap`][bootstrap] script.

## Running

Building and running the project is as simple as cloning the repository, opening [`Afterpay.xcworkspace`][afterpay-workspace] and building the `Afterpay` target. The example project can be built and run via the `Example` target.

# Contributing

Contributions are welcome! Please read our [contributing guidelines][contributing].

# License

This project is licensed under the terms of the Apache 2.0 license. See the [LICENSE][license] file for more information.

<!-- Links: -->
[afterpay-workspace]: Afterpay.xcworkspace
[badge-ci]: https://github.com/afterpay/sdk-ios/workflows/Build%20and%20Test/badge.svg?branch=master&event=push
[badge-carthage]: https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat
[badge-ccp]: http://img.shields.io/cocoapods/v/Afterpay.svg?style=flat
[badge-license]: http://img.shields.io/cocoapods/l/Afterpay.svg?style=flat
[badge-platform]: http://img.shields.io/cocoapods/p/Afterpay.svg?style=flat
[badge-spm]: https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat
[badge-black-on-mint]: Images/badge_black_on_mint.png
[badge-mint-on-black]: Images/badge_mint_on_black.png
[badge-white-on-black]: Images/badge_white_on_black.png
[badge-black-on-white]: Images/badge_black_on_white.png
[button-black-on-mint]: Images/button_black_on_mint.png
[button-mint-on-black]: Images/button_mint_on_black.png
[button-white-on-black]: Images/button_white_on_black.png
[button-black-on-white]: Images/button_black_on_white.png
[bootstrap]: Scripts/bootstrap
[carthage]: https://github.com/Carthage/Carthage
[ccp]: https://cocoapods.org/pods/Afterpay
[contributing]: CONTRIBUTING.md
[example]: Example
[example-server]: https://github.com/afterpay/sdk-example-server
[express-checkout]: https://developers.afterpay.com/afterpay-online/reference#what-is-express-checkout
[four-payments]: Images/four-payments.png
[widget-screenshot]: Images/widget.png
[git-submodule]: https://git-scm.com/docs/git-submodule
[latest-release]: https://github.com/afterpay/sdk-ios/releases/latest
[license]: LICENSE
[mint]: https://github.com/yonaskolb/Mint
[mint-directory]: Tools/mint
[spm]: https://github.com/apple/swift-package-manager
[trust-kit]: https://github.com/datatheorem/TrustKit
