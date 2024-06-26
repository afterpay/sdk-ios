# Afterpay iOS SDK

![Build and Test][badge-ci]
[![Swift Package Manager compatible][badge-spm]][spm]
[![Carthage compatible][badge-carthage]][carthage]
[![CocoaPods compatible][badge-ccp]][ccp]
![Platform][badge-platform]
![License][badge-license]


# Documentation
Documentation for usage can be found [here][docs], including the [getting started][docs-getting-started] guide and [UI component][docs-ui] docs.

# Checkout V3

```swift
Afterpay.presentCheckoutV3Modally(over:consumer:total:items:animated:configuration:requestHandler:completion:)
```

Checkout version 3 returns a unique single use card for you to use in your existing checkout flow.

The configuration object may be set using `setV3Configuration`, or passed into the checkout call.

## Configuration

```swift
Afterpay.fetchMerchantConfiguration(configuration:requestHandler:completion:)
```

As v3 removes the need for merchant integration with the Afterpay API, the `Configuration` — providing information about minimum and maximum order amounts — is now available through the SDK.

The configuration object may be set using `setV3Configuration`, or passed into the checkout call.

# Contributing

Contributions are welcome! Please read our [contributing guidelines][contributing].

# License

This project is licensed under the terms of the Apache 2.0 license. See the [LICENSE][license] file for more information.

<!-- Links: -->
[docs]: https://afterpay.github.io/sdk-ios
[docs-ui]: https://afterpay.github.io/sdk-ios/ui-components/
[docs-getting-started]: https://afterpay.github.io/sdk-ios/getting-started/

[badge-ci]: https://github.com/afterpay/sdk-ios/workflows/Build%20and%20Test/badge.svg?branch=master&event=push
[badge-spm]: https://img.shields.io/badge/SPM-compatible-4BC51D.svg?style=flat
[badge-carthage]: https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat
[badge-ccp]: https://img.shields.io/cocoapods/v/Afterpay.svg?style=flat
[badge-license]: https://img.shields.io/cocoapods/l/Afterpay.svg?style=flat
[badge-platform]: https://img.shields.io/cocoapods/p/Afterpay.svg?style=flat
[spm]: https://github.com/apple/swift-package-manager
[carthage]: https://github.com/Carthage/Carthage
[ccp]: https://cocoapods.org/pods/Afterpay
[license]: LICENSE
[contributing]: CONTRIBUTING.md
