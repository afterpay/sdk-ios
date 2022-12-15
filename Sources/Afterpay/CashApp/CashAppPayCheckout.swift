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
  private let completion: (_ result: CheckoutResult) -> Void

  private var didCommenceCheckout: DidCommenceCheckoutClosure? {
    didCommenceCheckoutClosure ?? getCashAppCheckoutHandler()?.didCommenceCheckout
  }

  public init(
    configuration: Configuration,
    didCommenceCheckout: DidCommenceCheckoutClosure?,
    completion: @escaping (_ result: CheckoutResult) -> Void
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
          print("hello-3", error.localizedDescription)
        }
      }
    }

//    switch tokenResult {
//    case .success(let token):
//      let url = URL(string: configuration.environment.cashAppSigningURL)!
//      var request = URLRequest(url: url)
//      request.setValue("application/json", forHTTPHeaderField: "Accept")
//      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//      request.httpMethod = "POST"
//      let requestBody: [String: Any] = [ "token": token ]
//      request.httpBody = try? JSONSerialization.data(withJSONObject: requestBody)
//
//      let session = URLSession.shared
//      session.dataTask(with: request) { data, _, error in
//        if let data = data {
//          do {
//            let decoder = JSONDecoder()
//            let checkoutCashResponse = try decoder.decode(CashAppPayCheckoutResponse.self, from: data)
//            let decodedJwt = checkoutCashResponse.decodeJwtToken()
//
//            print(decodedJwt)
//          } catch {
//            print(error)
//          }
//        }
//      }.resume()
//    case .failure(let error):
//      print("hello-ono", error.localizedDescription) // TODO: handle failure of token
//    }
  }

  private func handleToken(token: Token) {
    let requestBody: [String: Any] = [ "token": token ]
    let jsonRequestBody = try? JSONSerialization.data(withJSONObject: requestBody)

    guard let request = createSigningRequest(jsonRequestBody: jsonRequestBody) else {
      return assertionFailure("Could not create signing request when handling CashApp token")
    }

    signPayment(request: request) { jwt in
      guard let jwt = jwt else {
        return assertionFailure("Could not return jwt when signing payment")
      }
      
      print("hello signed payment", jwt)
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
    signingCompletion: @escaping (_ jwt: CashAppPayCheckoutJWT?) -> Void
  ) {
    URLSession.shared.dataTask(with: request) { data, response, error in
      do {
        if let data = data {
          let httpResponse = response as! HTTPURLResponse

          if 200...299 ~= httpResponse.statusCode {
            let decoder = JSONDecoder()
            let checkoutCashResponse = try decoder.decode(CashAppPayCheckoutResponse.self, from: data)
            let decodedJwt = checkoutCashResponse.decodeJwtToken()

            signingCompletion(decodedJwt)
          } else {
            assertionFailure("Could not sign payment. HTTP status code: \(httpResponse.statusCode)")
            signingCompletion(nil)
          }
        }
      } catch {
        assertionFailure("Could not decode JWT when attempting to sign payment. Reason: \(error)")
        signingCompletion(nil)
      }
    }.resume()
  }
  
  private func createCashPayment(jwt: CashAppPayCheckoutJWT) {
    
  }
}
