---
layout: default
title: Cash App Pay with Checkout V3
parent: Getting Started
nav_order: 6
---

# Cash App Pay with Checkout V3
{: .d-inline-block .no_toc }
NEW (v5.7.0)
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

This method requires importing and implementing the Cash App PayKit SDK.

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

Your implementation should switch on the `state` parameter and respond to each of the [state changes](#states). Below is a partial implementation of the most important states.

```swift
func stateDidChange(to state: CashAppPayState) {
    switch state {
    case let .readyToAuthorize(customerRequest):
        // The customer is ready to authorize the Customer Request by deep linking in to Cash App.
        // Enable the Cash App Pay Button.
    case let .approved(request: customerRequest, grants: grants):
        // The customer has deep linked back to your App from Cash App and they approved the Customer Request!
        // The checkout is now complete.
    case let .declined(customerRequest):
        // The customer has deep linked back to your App from Cash App and the Customer Request is declined.
        // This Customer Request is in a terminal state and any subsequent actions on this Customer Request will yield an error.
        // To retry the customer will need to restart the Customer Request flow.
        // You should make sure customers can select other payment methods at this point.
    case .redirecting:
        // The customer is being redirected to Cash App you can present a loading spinner if desired.
        // NOTE: In the event that the customer does not have Cash App installed and navigates back to your app then it is
        // up to you to set a reasonable timeout after which you dismiss the loading spinner and treat the Customer Request as failed.
    case .integrationError:
        // There is an issue with the way you are transitioning between states. Refer to the documentation to ensure you are
        // moving between states in the correct order.
        // You can perform a valid transition from this state.
    case .apiError:
        // Cash App Pay API is suffering degraded performance. You can can retry your event or discard this checkout.
        // Retrying may fix the issue or reach out to Developer Support for additional help.
    case .unexpectedError:
        // This should never happen however in the event you receive this please reach out to Developer Support to diagnose the issue.
    case .networkError:
        // The Cash App Pay SDK attempts to retry network failures however in the event that a customer is unable
        // to perform their checkout due to network connectivity issues you may want to retry the checkout.
    ...
    // handle the other state changes
    ...
    }
}
```

### States

{: .info }
> You must update your UI in response to these state changes.

Your implementation should switch on the `state` parameter and handle the appropriate state changes. Some of these possible states are for information only, but most drive the logic of your integration. The most critical states to handle are listed in the table below:

| State | Description |
|:------|:------------|
|`readyToAuthorize` | Show a Cash App Pay button in your UI and call `authorizeCustomerRequest()` when it is tapped. |
|`approved` |Grants are ready for your backend to use to create a payment.|
|`declined`|Customer has declined the Cash App Pay authorization and must start the flow over or choose a new payment method.|

{: .alert }
> Customer Requests can fail for a number of reasons, such as when customer exits the flow prematurely or are declined by Cash App for risk reasons. You must respond to these state changes and be ready to update your UI appropriately.

### Error States

| State | Description |
|:------|:------------|
|`integrationError` |A fixable bug in your integration.|
|`apiError` | A degradation of Cash App Pay server APIs. Your app should temporarily hide Cash App Pay functionality. |
|`unexpectedError` |A bug outside the normal flow. Report this bug (and what caused it) to Cash App Developer Support. |
|`networkError` |A networking error, likely due to poor internet connectivity. |

### Informational states

| State | Description |
|:------|:------------|
|`notStarted`|Ready for a Create Customer Request to be initiated.|
|`creatingCustomerRequest` |CustomerRequest is being created. For information only.|
|`updatingCustomerRequest`|CustomerRequest is being updated. For information only.|
|`redirecting`|SDK is redirecting to Cash App for authorization. Show loading indicator if desired.|
|`polling`|SDK is retrieving authorized CustomerRequest. Show loading indicator if desired.|
|`refreshing`|CustomerRequest is being refreshed as a result of the AuthFlowTriggers expiring. Show loading indicator if desired|

## Step 3: Implement URL handling

To use PayKit iOS, Cash App must be able to call a URL that will redirect back to your app. The simplest way to accomplish this is via [Custom URL Schemes][custom-url-schemes], but if your app supports [Universal Links][universal-links] you may use those URLs as well.

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

{: .alert }
> This step is vital to ensuring the integration works correctly! You may find that in testing environments this step is not required however in production environments you will see a high number of customers not being able to complete their checkout because the SDK never enters the polling state.

## Step 4: Configure Afterpay for V3 Checkouts

Set the V3 configuration as follows:
```swift
Afterpay.setV3Configuration(
  CheckoutV3Configuration(
        shopDirectoryMerchantId: "merchant_id",
        region: .US,
        environment: .production
  )
)
```

## Step 5: Perform V3 Checkout

Call `checkoutV3WithCashAppPay` and store the results:
```swift
Afterpay.checkoutV3WithCashAppPay(
    consumer: Consumer(email: "example@email.com"),
    orderTotal: OrderTotal(total: 100, shipping: .zero, tax: .zero)
  ) { result in
    switch result {
    case .success(let checkoutV3):
      // Store the token
      // Store the singleUseCardToken
      // Store the jwt, amount, redirectUri and brandID from the CashAppSigningData
    case .cancelled(let reason):
      // Handle reason
    case .failure(let error):
      // Handle error
    }
  }
```

## Step 6: Instantiate Pay Kit iOS

When you’re ready to authorize a payment using Cash App Pay,

1. Instantiate the SDK with the Afterpay Cash App Pay Client ID via `Afterpay.checkoutV3CashAppClientId`.
2. The SDK defaults to point to the production endpoint; for development, set the endpoint to `.sandbox`.
3. Register your observer to the Pay Kit SDK.

{: .note }
> Ensure that the Afterpay SDK is configured per Step 4 before attempting to access `Afterpay.checkoutV3CashAppClientId`.

For example, from your checkout view controller that implements the `PayKitObserver` protocol, you might instantiate the SDK to be:

``` swift
private let sandboxClientID = Afterpay.checkoutV3CashAppClientId
private lazy var sdk: CashAppPay = {
    let sdk = CashAppPay(clientID: sandboxClientID, endpoint: .sandbox)
    sdk.addObserver(self)
    return sdk
}()
```
## Step 7: Create a Customer Request

You can create a customer request as soon as you know the amount you’d like to charge or if you'd like to create an on-file payment request. You must create this request as soon as your checkout view controller loads, so that your customer can authorize the request without delay.

To charge a one-time payment, your **Create Request** call might look like this (in the following example, `checkoutV3` is the response object that is returned in the `checkoutV3WithCashAppPay` parameter from step 5):

``` swift
paykit.createCustomerRequest(
  params: CreateCustomerRequestParams(
    actions: [
      .oneTimePayment(
        scopeID: checkoutV3.cashAppSigningData.brandId,
        money: Money(
          amount: checkoutV3.cashAppSigningData.amount,
          currency: .USD
        )
      ),
    ],
    channel: .IN_APP,
    redirectURL: URL(string: checkoutV3.cashAppSigningData.redirectUri)!,
    referenceID: nil,
    metadata: nil
  )
)
```

Your Observer’s state will change to `.creatingCustomerRequest`, then `.readyToAuthorize` with the created `CustomerRequest` struct as an associated value.

## Step 8: Authorize the Customer Request

Once the SDK is in the `.readyToAuthorize` state, you can store the associated `CustomerRequest` and display a Cash App Pay button. When the Customer taps the button, you can authorize the customer request. See [CashAppPayButton][cash-button]{:target='_blank'} to learn more about the Cash App Pay button component.

**Example**

``` swift
@objc func cashAppPayButtonTapped() {
  sdk.authorizeCustomerRequest(request)
}
```

Your app will redirect to Cash App for authorization. When the authorization is completed, your redirect URL will be called and the `RedirectNotification` will post. Then, the SDK will fetch your authorized request and return it to your Observer, as part of the change to the `.approved` state.

### Unhappy Path

If the Customer does not have Cash App installed on thier device then they will redriect to a webpage prompting them to download Cash App. In the event the customer does not download Cash App, then the SDK will remain in the `polling` state. The SDK does not handle this edge case and instead it is up to the implementor to set a reasonable timeout and treat the checkout as failed once that timeout is exceeded. It is suggested to dismiss any loading states and restart the Cash App Pay flow as to not block the customer from checking out.

## Step 9: Confirm the Cash App Pay Order

Back in Afterpay, confirm the payment using the `checkoutV3` data from step 5 and the `customerRequest.grant` from step 8:

```swift
Afterpay.checkoutV3ConfirmForCashAppPay(
    token: checkoutV3.token,
    singleUseCardToken: checkoutV3.singleUseCardToken,
    cashAppPayCustomerID: grant.customerID,
    cashAppPayGrantID: grant.id,
    jwt: checkoutV3.cashAppSigningData.jwt
  ) { result in
    switch result {
    case .success(let success):
      // Recieve Card Details and the date by which the card must be used
    case .failure(let failure):
      // Handle failure
    }
  }
```


## Sequence Diagram

The below diagram describes the happy path.

``` mermaid
%%{
  init: {
    'theme': 'base',
    'themeVariables': {
      'primaryColor': '#00c846',
      'primaryTextColor': '#FFFFFF',
      'primaryBorderColor': '#dfdfdf',
      'signalTextColor': '#000000',
      'signalColor': '#000000',
      'secondaryColor': '#006100',
      'tertiaryColor': '#fff'
    }
  }
}%%

sequenceDiagram
  participant App
  participant Afterpay SDK
  participant Cash App Pay SDK
  participant Afterpay API
  Note over App,Afterpay API: Setup
  App->>Afterpay SDK: Configure the SDK
  Note over App,Afterpay SDK: Required for setting environment
  App->>Cash App Pay SDK: Create Cash App Pay instance
  Note over App,Cash App Pay SDK: Ensure same environment<br>as Afterpay SDK config
  App->>App: Implement<br>deep linking
  App->>Cash App Pay SDK: Register for state updates
  App->>Afterpay SDK: Create a Checkout
  Afterpay SDK->>Afterpay API: Creates a Vistual Card
  Afterpay API-->>App: Checkout result with <br> Single Use Payment Card
  Note over App,Afterpay API: Create Customer Request and Capture
  App->>Cash App Pay SDK: Create a customer request
  App->>Cash App Pay SDK: Authorize the customer request
  App->>App: Handle payment<br>capture response
```

[custom-url-schemes]: https://developer.apple.com/documentation/xcode/defining-a-custom-url-scheme-for-your-app
[universal-links]: https://developer.apple.com/ios/universal-links/
[afterpay-configuration]: ../configuration
[cash-button]: https://cashapp-pay.stoplight.io/docs/api/technical-documentation/sdks/pay-kit/ios-getting-started#cashapppaybutton
[afterpay-create-checkout-endpoint]: https://developers.afterpay.com/afterpay-online/reference/create-checkout-1
[example-server-props]: https://github.com/afterpay/sdk-example-server/blob/5781eadb25d7f5c5d872e754fdbb7214a8068008/src/routes/checkout.ts#L26-L27
[api-reference-props]: https://developers.afterpay.com/afterpay-online/reference/javascript-afterpayjs#redirect-method