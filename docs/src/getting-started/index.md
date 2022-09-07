---
layout: default
title: Getting Started
has_children: true
nav_order: 4
---

# Getting Started
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

We provide options for integrating the SDK in Swift and Objective-C.

## Checkouts

Provided the URL or token generated during the checkout process we take care of pre approval process during which the user will log into Afterpay. The provided integration makes use of cookie storage such that returning customers will only have to re-authenticate with Afterpay once their existing sessions have expired. There are currently two versions of web checkout.

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
