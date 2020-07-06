# Afterpay iOS SDK

![Build and Test][badge-ci] [![Carthage compatible][badge-carthage]][carthage]

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
    - [Download](#download)
      - [GitHub Release](#github-release)
      - [Git Submodule](#git-submodule)
    - [Framework Integration](#framework-integration)
- [Features](#features)
  - [Web Checkout](#web-checkout)
- [Getting Started](#getting-started)
  - [Presenting Web Checkout](#presenting-web-checkout)
    - [In code (UIKit)](#in-code-uikit)
    - [In code (SwiftUI)](#in-code-swiftui)
    - [In Interface Builder](#in-interface-builder)
- [Examples](#examples)
- [Building](#building)
- [Contributing](#contributing)
- [License](#license)

# Integration

## Requirements

- iOS 12.0+
- Swift 5.0+

## CocoaPods

```
pod 'afterpay-ios', '~> 1.0'
```

## Carthage

```
github "afterpay/afterpay-ios" ~> 1.0
```

## Swift Package Manager

```
dependencies: [
    .package(url: "https://github.com/afterpay/afterpay-ios.git", .upToNextMajor(from: "1.0.0"))
]
```

## Manual

If you prefer not to use any of the supported dependency managers, you can choose to manually integrate the Afterpay SDK into your project.

### Download

#### GitHub Release

Download the [latest release][latest-release] from GitHub and unzip into an `Afterpay` directory in the root of your working directory.

#### Git Submodule

Add the Afterpay SDK as a [git submodule][git-submodule] by navigating to the root of your working directory and running the following commands:

```
git submodule add https://github.com/ittybittyapps/afterpay-ios.git Afterpay
cd Afterpay
git checkout 0.0.1
```

### Framework Integration

Now that the Afterpay SDK resides in the `Afterpay` directory in the root of your working directory, it can be added to your project or workspace with the following steps:

1. Open the new `Afterpay` directory, and drag `Afterpay.xcodeproj` into the Project Navigator of your application's Xcode project or workspace.
2. Select your application project in the Project Navigator to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
3. In the tab bar at the top of that window, open the "General" panel.
4. Click on the `+` button under the "Frameworks, Libraries, and Embedded Content" section.
5. Select the `Afterpay.framework` for your target platform.

And that's it, the Afterpay SDK is now ready to import and use within your application.

# Features

The initial release of the SDK contains the web login and pre approval process with more features to come in subsequent releases.

## Web Checkout

Provided the token generated during the checkout process we take care of pre approval process during which the user will log into Afterpay. The provided integration accounts for cookie storage such that returning customers will only have to re-authenticate with Afterpay once their existing sessions have expired.

# Getting Started

We provide options for integrating the SDK in UIKit and SwiftUI.

## Presenting Web Checkout

The Web Login is a UIViewController that can be presented in the context of your choosing.

### UIKit

```swift
final class MyViewController: UIViewController {
  // ...
  @objc func didTapPayWithAfterpay {
    let webLoginViewController = AfterpayWebLoginViewController(url: redirectCheckoutUrl)
    present(webLoginViewController, animated: true)
  }
}
```

### SwiftUI

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

# Examples

The [example project][example] demonstrates how to include an Afterpay payment flow using our prebuilt UI components.

# Building

The Afterpay SDK uses [Mint][mint] to install and run Swift command line packages. This has been pre-compiled and included in the repository under the [`Tools/mint`][mint-directory] directory, meaning it does not need to be installed or managed externally. Mint will automatically download the packages it manages on demand.

Building the project is as simple as cloning the repository, opening [`Afterpay.xcworkspace`][afterpay-workspace] and building the `Afterpay` target. The example project can be built and run via the `Example` target.

# Contributing

Contributions are welcome! Please read our [contributing guidelines][contributing].

# License

This project is licensed under the terms of the Apache 2.0 license. See the [LICENSE][license] file for more information.

<!-- Links: -->
[afterpay-workspace]: Afterpay.xcworkspace
[badge-ci]: https://github.com/ittybittyapps/afterpay-ios/workflows/Build%20and%20Test/badge.svg?branch=master&event=push
[badge-carthage]: https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat
[carthage]: https://github.com/Carthage/Carthage
[contributing]: CONTRIBUTING.md
[example]: Example
[git-submodule]: https://git-scm.com/docs/git-submodule
[latest-release]: https://github.com/ittybittyapps/afterpay-ios/releases/latest
[license]: LICENSE
[mint]: https://github.com/yonaskolb/Mint
[mint-directory]: Tools/mint
