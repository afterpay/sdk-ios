---
layout: default
title: Payment Button
parent: UI Components
nav_order: 3
---

# Payment Button

The Afterpay `PaymentButton` is a subclass of `UIButton` that can be scaled to suit your layout, to guarantee legibility it has a maximum width constraint of 256 points.

Below are examples of the button in each of the [color schemes](../#color-schemes):

| Mint and Black | Black and White |
| -- | -- |
| ![Black on Mint button][button-black-on-mint] | ![White on Black button][button-white-on-black] |
| ![Mint on Black button][button-mint-on-black] | ![Black on White button][button-black-on-white] |

There are also a few other kinds of payment available, with different wording:

* Buy Now
* Checkout
* Pay Now
* Place Order

Using a `PaymentButton` is easy. Configure it with some parameters sent to its initialiser. These parameters are optional, however.

```swift
let payButton = PaymentButton(
    colorScheme: .dynamic(
        lightPalette: .blackOnMint,
        darkPalette: .mintOnBlack
    ),
    buttonKind: .checkout
)
```

[button-black-on-mint]: ../images/button_black_on_mint.png
[button-mint-on-black]: ../images/button_mint_on_black.png
[button-white-on-black]: ../images/button_white_on_black.png
[button-black-on-white]: ../images/button_black_on_white.png
