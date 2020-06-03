# Afterpay iOS SDK
The Afterpay iOS SDK provides conveniences to make your Afterpay integration experience as smooth and straightforward as possible. We're working on crafting a great framework for developers with easy drop in components to make payments easy for your customers.

# Table of Contents

- [Afterpay iOS SDK](#afterpay-ios-sdk)
- [Table of Contents](#table-of-contents)
  - [Integration](#integration)
    - [Requirements](#requirements)
    - [CocoaPods](#cocoapods)
    - [Carthage](#carthage)
    - [Swift Package Manager](#swift-package-manager)
    - [Manual](#manual)
      - [Manual Download](#manual-download)
      - [Git Submodule](#git-submodule)
  - [Features](#features)
    - [Web Checkout](#web-checkout)
  - [Getting Started](#getting-started)
    - [Presenting Web Checkout](#presenting-web-checkout)
      - [In code (UIKit)](#in-code-uikit)
      - [In code (SwiftUI)](#in-code-swiftui)
      - [In Interface Builder](#in-interface-builder)

## Integration

### Requirements
- iOS 12.0+
- Swift 5.0+

### CocoaPods

```
pod 'afterpay-ios', '~> 1.0'
```

### Carthage

```
github "afterpay/afterpay-ios" ~> 1.0
```

### Swift Package Manager

```
dependencies: [
    .package(url: "https://github.com/afterpay/afterpay-ios.git", .upToNextMajor(from: "1.0.0"))
]
```

### Manual
You can always add the Afterpay SDK as an embedded framework manually if you prefer

#### Manual Download
Download instructions

#### Git Submodule
Git submodule instructions

## Features
The initial release of the SDK contains the web login and pre approval process with more features to come in subsequent releases.

### Web Checkout
Provided the token generated during the checkout process we take care of pre approval process during which the user will log into Afterpay. The provided integration accounts for cookie storage such that returning customers will only have to re-authenticate with Afterpay once their existing sessions have expired.

## Getting Started
We provide options for integrating via code, interface builder or even SwiftUI

### Presenting Web Checkout
The Web Login is a UIViewController that can be presented in the context of your choosing

#### In code (UIKit)
```swift
final class MyViewController: UIViewController {
  // ...
  @objc func didTapPayWithAfterpay {
    let webLoginViewController = AfterpayWebLoginViewController(url: redirectCheckoutUrl)
    present(webLoginViewController, animated: true)
  }
}
```

#### In code (SwiftUI)
```swift
struct MyView: View {
  // ...
  var body: some View {
    NavigationView {
      NavigationLink(destination: AfterpayWebLoginView(url: self.redirectCheckoutUrl)) {
        Text("Pay with Afterpay")
      }.buttonStyle(PlainButtonStyle())
    }
  }
}
```

#### In Interface Builder

In your storyboard:

In your view controller:
```swift
final class MyViewController: UIViewController {
  // ...
  override func prepareForSegue(segue: UIStoryboardSegue, sender: Any?) {
    if let webLoginViewController = segue.destination as? AfterpayWebLoginViewController {
        webLoginViewController.url = redirectCheckoutUrl
    }
  }
}
```