---
layout: default
title: Lockup
parent: UI Components
nav_order: 2
---

# Lockup

The Afterpay lockup is a simple `UIView` that can be scaled to suit the needs of your app. As per branding guidelines it has a minimum width constraint of 64 points.

{: .note }
Only the foreground color will be applied to the lockup. Background will always be transparent.

```swift
let lockupView = LockupView()

// optionally set a color scheme
lockupView.colorScheme = .dynamic(lightPalette: .blackOnMint, darkPalette: .mintOnBlack)
```

Below are examples of the lockup in each of the [color schemes](../#color-schemes):
![Black Lockup][lockup-black] ![White Lockup][lockup-white] ![Mint Lockup][lockup-mint]

[lockup-black]: ../images/lockup-black.png
[lockup-white]: ../images/lockup-white.png
[lockup-mint]: ../images/lockup-mint.png
