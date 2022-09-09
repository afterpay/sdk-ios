---
layout: default
title: UI Components
has_children: true
nav_order: 5
---

# UI Components

The Afterpay Android SDK provides powerful and customizable UI elements that can be used out-of-the-box to allow users to shop now and pay later.

{: .info }
The Afterpay SDK contains a list of valid consumer locales that are available for each Configuration locale. If none are matched then the checkouts will not work. Therefore, in such a situation, all presentation elements will be hidden. Furthermore, a public read-only property is available at `Afterpay.enabled`, and this will be set to `false`. This property should be used to conditionally show or hide any related views to avoid a scenario where empty views take up unnecessary space. A simple implementation of this can be seen in the example app, specifically in the `CartViewController`, `ComponentsViewController` and `WidgetViewController`.

## Color Schemes

Color schemes can be set on the badge view or payment button to either have a single style in both light and dark mode or to change automatically.

```swift
// Always black on mint
badgeView.colorScheme = .static(.blackOnMint)

// White on black in light mode and black on white in dark mode
badgeView.colorScheme = .dynamic(lightPalette: .whiteOnBlack, darkPalette: .blackOnWhite)
```
