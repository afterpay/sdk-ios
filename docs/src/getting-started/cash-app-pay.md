---
layout: default
title: Cash App Pay
parent: Getting Started
nav_order: 4
---

# Cash App Pay
{: .d-inline-block .no_toc }
NEW (v5.3.0)
{: .label .label-green }


<details markdown="block">
  <summary>
    Table of contents
  </summary>
  {: .text-delta }
- TOC
{:toc}
</details>


{: .alert }
> Cash App Pay is currently available in the following region(s): US

With our latest enhancements, you can now support taking Cash App Pay payments using your Afterpay merchant account. To do this, you must generate a token by sending a server-to-server call to the [Afterpay API Create Checkout endpoint][afterpay-create-checkout-endpoint]{:target="_blank"} with a parameter of `isCashAppPay` set to `true`. This method requires importing and implementing the Cash App PayKit SDK.

{: .info }
> When creating a checkout token, you must set both `redirectConfirmUrl` and `redirectCancelUrl`. If they are not set, an error will be returned from the server and the SDK will ouput a malformed JSON error. The SDK’s example merchant server sets the parameters [here][example-server-props]{:target='_blank'}. See more details at [Redirect Method][api-reference-props]{:target='_blank'} in the Standard Checkout API.

## Step 1: Install the Cash App Pay Kit SDK

### Installation (Option One): SPM
You can install Pay Kit via SPM. Create a new Xcode project and navigate to `File > Swift Packages > Add Package Dependency`. Enter the URL `https://github.com/cashapp/cash-app-pay-ios-sdk` and tap **Next**. Choose the `main` branch, and on the next screen, download the required packages.

### Installation (Option Two): Cocoapods
Add Cocoapods to your project. Open the `Podfile` and add `pod 'CashAppPayKit'` and/or `pod 'CashAppPayKitUI'` and save your changes. Run `pod update` and Pay Kit will now be included through Cocoapods.

## Step 2: Implement the Cash App Pay Observer Protocol

To receive updates from Pay Kit, you’ll need to implement the Cash App Pay Observer protocol. Your checkout view controller can conform to this protocol, or you can create a dedicated observer class.

The `CashAppPayObserver` protocol contains only one method:

``` swift
func stateDidChange(to state: CashAppPaySDKState) {
	// handle state changes
}
```


### States

Your implementation should switch on the `state` parameter and handle the appropriate state changes. Some of these possible states are for information only, but most drive the logic of your integration. The most critical states to handle are listed in the table below:

| State | Description |
|:------|:------------|
| `ReadyToAuthorize` | Show a Cash App Pay button in your UI and call `authorizeCustomerRequest()` when it is tapped. |
| `Approved` | Grants are ready for your backend to use to create a payment. |
| `Declined` | Customer has declined the Cash App Pay authorization and must start the flow over or choose a new payment method. |

### Error States

| State | Description |
|:------|:------------|
| `.integrationError` | A fixable bug in your integration. |
| `.apiError` | A degradation of Cash App Pay server APIs. Your app should temporarily hide Cash App Pay functionality. |
| `.unexpectedError` | A bug outside the normal flow. Report this bug (and what caused it) to Cash App Developer Support. |

{: .info }
> You must update your UI in response to these state changes.

## Step 3: Implement URL handling

To use Pay Kit iOS, Cash App must be able to call a URL that will redirect back to your app. The simplest way to accomplish this is via [Custom URL Schemes][custom-url-schemes], but if your app supports [Universal Links][universal-links] you may use those URLs as well.

Choose a unique scheme for your application and register it in Xcode from the **Info** tab of your application’s Target.

You’ll pass a URL that uses this scheme (or a Universal Link your app handles) into the `createCustomerRequest()` method that starts the authorization process.

When your app is called back by Cash App, simply post the `CashAppPay.RedirectNotification` from your `AppDelegate` or `SceneDelegate`, and the SDK will handle the rest:

``` swift
import UIKit
import PayKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
    if let url = URLContexts.first?.url {
      NotificationCenter.default.post(
        name: CashAppPay.RedirectNotification,
        object: nil,
        userInfo: [UIApplication.LaunchOptionsKey.url : url]
      )
    }
  }
}
```

## Step 4: Instantiate Pay Kit iOS

When you’re ready to authorize a payment using Cash App Pay,

1. Instantiate the SDK with the Afterpay Pay Kit Client ID via `Afterpay.cashAppClientId`.
2. The SDK defaults to point to the production endpoint; for development, set the endpoint to `.sandbox`.
3. Add your observer to the Pay Kit SDK.

{: .note }
> Ensure that the Afterpay SDK is configured per the [instructions][afterpay-configuration] before attempting to access `Afterpay.cashAppClientId`.

For example, from your checkout view controller that implements the `PayKitObserver` protocol, you might instantiate the SDK to be:

``` swift
private let sandboxClientID = Afterpay.cashAppClientId
private lazy var sdk: CashAppPay = {
    let sdk = CashAppPay(clientID: sandboxClientID, endpoint: .sandbox)
    sdk.addObserver(self)
    return sdk
}()
```
## Step 5: Create a Customer Request

You can create a customer request as soon as you know the amount you’d like to charge or if you'd like to create an on-file payment request. You must create this request as soon as your checkout view controller loads, so that your customer can authorize the request without delay.

### Step 5A: Sign the Order Token

After retrieving the token from your server-to-server call, the order must be signed, so that you can retrieve the JWT and associated data. This might look like the following example:

``` swift
let token = retrieveTokenFromServerToServerCall()
Afterpay.signCashAppOrderToken(token) { result in
  switch result {
  case .success(let cashData):
    // TODO: use `cashData` to create customer request (step 5B)
  case .failed(let reason):
    // TODO: handle failed signing either by retrying with a new Cash App
    // token or disabling / hiding the Cash App Pay button
  }
}
```

### Step 5B: Create a Pay Kit Customer Request

To charge a one-time payment, your **Create Request** call might look like this (in the following example, `cashData` is the response object that is returned in the `didCommenceCheckout` parameter from step 5A):

``` swift
paykit.createCustomerRequest(
  params: CreateCustomerRequestParams(
    actions: [
      .oneTimePayment(
        scopeID: cashData.brandId,
        money: Money(
          amount: cashData.amount,
          currency: .USD
        )
      ),
    ],
    channel: .IN_APP,
    redirectURL: URL(string: cashData.redirectUri)!,
    referenceID: nil,
    metadata: nil
  )
)
```

Your Observer’s state will change to `.creatingCustomerRequest`, then `.readyToAuthorize` with the created `CustomerRequest` struct as an associated value.

## Step 6: Authorize the Customer Request

### Step 6A: Add an Authorize Request Event to Cash App Pay button

Once the SDK is in the `.readyToAuthorize` state, you can store the associated `CustomerRequest` and display a Cash App Pay button. When the Customer taps the button, you can authorize the customer request. See [CashAppPayButton][cash-button]{:target='_blank'} to learn more about the Cash App Pay button component.

**Example**

``` swift
@objc func cashAppPayButtonTapped() {
  sdk.authorizeCustomerRequest(request)
}
```

Your app will redirect to Cash App for authorization. When the authorization is completed, your redirect URL will be called and the `RedirectNotification` will post. Then, the SDK will fetch your authorized request and return it to your Observer, as part of the change to the `.approved` state.



### Step 6B: Validate the Cash App Pay Order

{: .alert }
This step must not be skipped

Finally, you must validate the Cash App order. This will look like the following example:

``` swift
Afterpay.validateCashAppOrder(jwt: cashData.jwt, customerId: customerId, grantId: grant.id) { result in
  switch result {
  case .success(let data):
    // TODO: handle successful validation (ie pass grant and token to backend and then redirect to receipt page)
  case .failed(let reason):
    // TODO: handle invalid Cash App Order (ie start payment flow again)
  }
}
```

## Step 7: Pass Grants to the Backend and Capture Payment

The approved customer request will have grants associated with it which can be used with Afterpay’s Capture Payment API. Pass the `grantId` along with the token to capture using a server-to-server request.


[custom-url-schemes]: https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app
[universal-links]: https://developer.apple.com/ios/universal-links/
[afterpay-configuration]: ../configuration
[cash-button]: https://cashapp-pay.stoplight.io/docs/api/technical-documentation/sdks/pay-kit/ios-getting-started#cashapppaybutton
[afterpay-create-checkout-endpoint]: https://developers.afterpay.com/afterpay-online/reference/create-checkout-1
[example-server-props]: https://github.com/afterpay/sdk-example-server/blob/5781eadb25d7f5c5d872e754fdbb7214a8068008/src/routes/checkout.ts#L26-L27
[api-reference-props]: https://developers.afterpay.com/afterpay-online/reference/javascript-afterpayjs#redirect-method
