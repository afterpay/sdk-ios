---
layout: default
title: Configuring the SDK
parent: Getting Started
nav_order: 1
---

# Configuring the SDK

Configuration is used by the SDK for rendering UI components with the correct branding and assets, T&Cs, web links, and currency formatting.

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
