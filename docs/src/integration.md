---
layout: default
title: Integration
nav_order: 2
---

# Integration
{: .no_toc }

<details open markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>

## Requirements

- iOS 12.0+
- Swift 5.3+
- Xcode 12.0+

{: .note }
> While the native code in the SDK is iOS 12+ compatible, the Afterpay / Clearpay checkout is a WebView wrapper for the web checkout. Browser support for this is currently iOS Safari 13.4+. It is up to the implementation to handle this difference. This allows apps that support users on iOS 12+ to use the SDK, but only users that meet the WebView requirements to access Afterpay / Clearpay.
>
> One method of doing so would be to hide all assets for users under iOS 13.4. This could be achieved using the `@available` attribute: `@available(iOS 13.4, *)`.

## Swift Package Manager (recommended)

This is the recommended integration method.

``` swift
dependencies: [
    .package(url: "https://github.com/afterpay/sdk-ios.git", .upToNextMajor(from: "5.4.0"))
]
```

## Carthage

``` swift
github "afterpay/sdk-ios" ~> 5.4
```

## CocoaPods

``` ruby
pod 'Afterpay', '~> 5.4'
```
## Manual

If you prefer not to use any of the supported dependency managers, you can choose to manually integrate the Afterpay SDK into your project.

### Source

#### GitHub Release

Download the [latest release][latest-release]{:target="_blank"} source zip from GitHub and unzip into an `Afterpay` directory in the root of your working directory.

#### Git Submodule

Add the Afterpay SDK as a [git submodule][git-submodule]{:target="_blank"} by navigating to the root of your working directory and running the following commands:

``` sh
git submodule add https://github.com/afterpay/sdk-ios.git Afterpay
cd Afterpay
git checkout 5.4.0
```

#### Project / Workspace Integration

Now that the Afterpay SDK resides in the `Afterpay` directory in the root of your working directory, it can be added to your project or workspace with the following steps:

1. Open the new `Afterpay` directory, and drag `Afterpay.xcodeproj` into the Project Navigator of your application's Xcode project or workspace.
2. Select your application project in the Project Navigator to navigate to the target configuration window and select the application target under the "Targets" heading in the sidebar.
3. In the tab bar at the top of that window, open the "General" panel.
4. Click on the `+` button under the "Frameworks, Libraries, and Embedded Content" section.
5. Select the `Afterpay.framework` for your target platform.

And that's it, the Afterpay SDK is now ready to import and use within your application.

[git-submodule]: https://git-scm.com/docs/git-submodule
[latest-release]: https://github.com/afterpay/sdk-ios/releases/latest
