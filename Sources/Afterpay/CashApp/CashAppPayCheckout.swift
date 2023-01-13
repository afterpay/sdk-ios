//
//  CheckoutCashAppPay.swift
//  Afterpay
//
//  Created by Scott Antonac on 7/12/2022.
//  Copyright © 2022 Afterpay. All rights reserved.
//

import Foundation

class CashAppPayCheckout {
  private let configuration: Configuration
  private let didCommenceCheckoutClosure: DidCommenceCheckoutClosure?
  private let completion: (_ result: CashAppResult) -> Void

  private var didCommenceCheckout: DidCommenceCheckoutClosure? {
    didCommenceCheckoutClosure ?? getCashAppCheckoutHandler()?.didCommenceCheckout
  }

  public init(
    configuration: Configuration,
    didCommenceCheckout: DidCommenceCheckoutClosure?,
    completion: @escaping (_ result: CashAppResult) -> Void
  ) {
    self.configuration = configuration
    self.didCommenceCheckoutClosure = didCommenceCheckout
    self.completion = completion
  }

  public func commenceCheckout() {
    guard let didCommenceCheckout = didCommenceCheckout else {
      return assertionFailure(
        "For checkout to function you must set `didCommenceCheckout` via either "
          + "`Afterpay.presentCheckoutV2Modally` or `Afterpay.setCheckoutV2Handler`"
      )
    }

    didCommenceCheckout { result in
      DispatchQueue.main.async {
        switch result {
        case (.success(let token)):
          self.handleToken(token: token)
        case (.failure(let error)):
          self.completion(.cancelled(reason: .error(error: error)))
        }
      }
    }
  }

  private func handleToken(token: Token) {
    let requestBody: [String: Any] = [ "token": token ]
    let jsonRequestBody = try? JSONSerialization.data(withJSONObject: requestBody)

    guard let request = createSigningRequest(jsonRequestBody: jsonRequestBody) else {
      return assertionFailure("Could not create signing request when handling CashApp token")
    }

    signPayment(request: request) { result in
      self.completion(result)
    }
  }

  private func createSigningRequest(jsonRequestBody: Data?) -> URLRequest? {
    guard let jsonRequestBody = jsonRequestBody else {
      return nil
    }

    let url = URL(string: configuration.environment.cashAppSigningURL)!
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = jsonRequestBody

    return request
  }

  private func signPayment(
    request: URLRequest,
    signingCompletion: @escaping (_ jwt: CashAppResult) -> Void
  ) {
    URLSession.shared.dataTask(with: request) { data, response, error in
      do {
        if let data = data {
          let httpResponse = response as! HTTPURLResponse

          if 200...299 ~= httpResponse.statusCode {
            let decoder = JSONDecoder()
            let checkoutCashResponse = try decoder.decode(CashAppPayCheckoutResponse.self, from: data)
            let decodedJwt = checkoutCashResponse.decodeJwtToken()

            guard let decodedJwt = decodedJwt else {
              signingCompletion(CashAppResult.cancelled(reason: .jwtDecodeNullError))
              return
            }

            guard let amount = self.amountToCents(amount: decodedJwt.amount.amount) else {
              signingCompletion(CashAppResult.cancelled(reason: .invalidAmount))
              return
            }

            guard let redirectURL = URL(string: decodedJwt.redirectUrl) else {
              signingCompletion(CashAppResult.cancelled(reason: .invalidRedirectUrl))
              return
            }

            let cashAppData = CashAppData(
              amount: amount,
              redirectUri: redirectURL,
              merchantId: decodedJwt.externalMerchantId,
              brandId: checkoutCashResponse.externalBrandId
            )

            signingCompletion(CashAppResult.success(data: cashAppData))
          } else {
            signingCompletion(CashAppResult.cancelled(reason: .httpError(errorCode: httpResponse.statusCode)))
            return
          }
        }
      } catch {
        signingCompletion(CashAppResult.cancelled(reason: .jwtDecodeError(error: error)))
        return
      }
    }.resume()
  }

  private func amountToCents(amount: String) -> UInt? {
    guard let double = Double(amount) else {
      return nil
    }

    let cents = double * 100

    if cents >= Double(UInt.min) && cents < Double(UInt.max) {
      return UInt(cents)
    }

    return nil
  }
}
