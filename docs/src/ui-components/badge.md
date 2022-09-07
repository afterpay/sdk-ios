---
layout: default
title: Badge
parent: UI Components
nav_order: 1
---

# Badge

The Afterpay badge is a simple `UIView` that can be scaled to suit the needs of your app. As per branding guidelines it has a minimum width constraint of 64 points.

```swift
let badgeView = BadgeView()

// optionally set a color scheme
lockupView.colorScheme = .dynamic(lightPalette: .blackOnMint, darkPalette: .blackOnWhite)
```

Below are examples of the badge in each of the [color schemes](../#color-schemes):

![Black on Mint badge][badge-black-on-mint] ![Mint on Black badge][badge-mint-on-black]

![White on Black badge][badge-white-on-black] ![Black on White badge][badge-black-on-white]

[badge-black-on-mint]: ../images/badge_black_on_mint.png
[badge-mint-on-black]: ../images/badge_mint_on_black.png
[badge-white-on-black]: ../images/badge_white_on_black.png
[badge-black-on-white]: ../images/badge_black_on_white.png
