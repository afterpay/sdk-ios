---
layout: default
title: Security
nav_order: 6
---

# Security
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

For added security, a method to hook into the SDKs WKWebView Authentication Challenge Handler is provided. With this you can implement things like SSL Pinning to ensure you can trust your end to end connections. An example of this has been provided in the [example project][example]{:target="_blank"} and in the snippet below using [TrustKit][trust-kit]{:target="_blank"}. In this handler you must return whether or not you have handled the challenge yourself (have called the completionHandler) by returning `true`, or if you wish to fall back to the default handling by returning `false`.

This technique is supported on both the checkout versions, and the widget.

## Swift

```swift
Afterpay.setAuthenticationChallengeHandler { challenge, completionHandler -> Bool in
 let validator = TrustKit.sharedInstance().pinningValidator
 return validator.handle(challenge, completionHandler: completionHandler)
}
```

## Objective-C

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

[example]: https://github.com/afterpay/sdk-ios/blob/master/Example
[trust-kit]: https://github.com/datatheorem/TrustKit
