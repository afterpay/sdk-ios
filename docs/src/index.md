---
layout: default
title: Home
nav_order: 1
---

# Welcome

Welcome to the Afterpay iOS SDK.

The Afterpay iOS SDK provides conveniences to make your Afterpay integration experience as smooth and straightforward as possible. We're working on crafting a great framework for developers with easy drop in components to make payments easy for your customers.

This documentation is the main source of documentation for developers implementing Afterpay / Clearpay in their iOS Apps. If this is your first time hearing about Afterpay or Clearpay or to view the developer docs, we recommend starting with the relevant links below.

#### Website

- [Afterpay][afterpay-website]{:target="_blank"} - (AU, CA, NZ, US)
- [Clearpay][clearpay-uk-website]{:target="_blank"} - (UK)
- [Clearpay][clearpay-eu-website]{:target="_blank"} - (ES, FR, IT)

#### Developer Documentation

- [Afterpay][afterpay-developer-site]{:target="_blank"} - (AU, CA, NZ, US)
- [Clearpay][clearpay-uk-developer-site]{:target="_blank"} - (UK)
- [Clearpay][clearpay-eu-developer-site]{:target="_blank"} - (ES, FR, IT)


## Building

### Mint

The Afterpay SDK uses [Mint][mint]{:target="_blank"} to install and run Swift command line packages. This has been pre-compiled and included in the repository under the [`Tools/mint`][mint-directory]{:target="_blank"} directory, meaning it does not need to be installed or managed externally.

{: .note }
> Mint will automatically download the packages it manages on demand. To speed up the initial build of the SDK, the packages can be downloaded by running the [`Scripts/bootstrap`][bootstrap]{:target="_blank"} script.

### Running

Building and running the project is as simple as cloning the repository, opening [`Afterpay.xcworkspace`][afterpay-workspace]{:target="_blank"} and building the `Afterpay` target. The example project can be built and run via the `Example` target.

## Contributing

Contributions are welcome! Please read our [contributing guidelines][contributing]{:target="_blank"}.

## License

This project is licensed under the terms of the Apache 2.0 license. See the [LICENSE][license]{:target="_blank"} file for more information.

[afterpay-website]: https://www.afterpay.com/
[afterpay-developer-site]: https://developers.afterpay.com/
[clearpay-uk-website]: https://www.clearpay.co.uk/
[clearpay-uk-developer-site]: https://developers.clearpay.co.uk/
[clearpay-eu-website]: https://www.clearpay.com/
[clearpay-eu-developer-site]: https://developers.clearpay.com/

[mint]: https://github.com/yonaskolb/Mint
[mint-directory]: https://github.com/afterpay/sdk-ios/tree/master/Tools/mint
[bootstrap]: https://github.com/afterpay/sdk-ios/tree/master/Scripts/bootstrap
[afterpay-workspace]: https://github.com/afterpay/sdk-ios/tree/master/Afterpay.xcworkspace
[contributing]:  https://github.com/afterpay/sdk-ios/tree/master/CONTRIBUTING.md
[license]:  https://github.com/afterpay/sdk-ios/tree/master/LICENSE
