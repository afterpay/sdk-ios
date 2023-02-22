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
  private let completion: (_ result: CashAppSigningResult) -> Void

  private var didCommenceCheckout: DidCommenceCheckoutClosure? {
    didCommenceCheckoutClosure ?? getCashAppCheckoutHandler()?.didCommenceCheckout
  }

  public init(
    configuration: Configuration,
    didCommenceCheckout: DidCommenceCheckoutClosure?,
    completion: @escaping (_ result: CashAppSigningResult) -> Void
  ) {
    self.configuration = configuration
    self.didCommenceCheckoutClosure = didCommenceCheckout
    self.completion = completion
  }

  internal func commenceCheckout() {
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
          self.completion(.failed(reason: .error(error: error)))
        }
      }
    }
  }

  private func handleToken(token: Token) {
    let requestBody: [String: Any] = [ "token": token ]
    let jsonRequestBody = try? JSONSerialization.data(withJSONObject: requestBody)

    guard let request = CashAppPayCheckout.createRequest(
      urlString: configuration.environment.cashAppSigningURL,
      jsonRequestBody: jsonRequestBody
    ) else {
      return assertionFailure("Could not create signing request when handling CashApp token")
    }

    signPayment(request: request) { result in
      self.completion(result)
    }
  }

  private static func createRequest(urlString: String, jsonRequestBody: Data?) -> URLRequest? {
    guard let jsonRequestBody = jsonRequestBody else {
      return nil
    }

    let url = URL(string: urlString)!
    var request = URLRequest(url: url)
    request.setValue("application/json", forHTTPHeaderField: "Accept")
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpMethod = "POST"
    request.httpBody = jsonRequestBody

    return request
  }

  private func signPayment(
    request: URLRequest,
    signingCompletion: @escaping (_ jwt: CashAppSigningResult) -> Void
  ) {
    URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
      if error != nil {
        signingCompletion(CashAppSigningResult.failed(reason: .error(error: error!)))
        return
      }

      do {
        if let data = data {
          let httpResponse = response as! HTTPURLResponse

          if 200...299 ~= httpResponse.statusCode {
            let decoder = JSONDecoder()
            let cashAppSigningResponse = try decoder.decode(CashAppSigningResponse.self, from: data)
            let decodedJwt = cashAppSigningResponse.decodeJwtToken()

            guard let decodedJwt = decodedJwt else {
              signingCompletion(CashAppSigningResult.failed(reason: .jwtDecodeNullError))
              return
            }

            guard let amount = self?.amountToCents(amount: decodedJwt.amount.amount) else {
              signingCompletion(CashAppSigningResult.failed(reason: .invalidAmount))
              return
            }

            guard let redirectURL = URL(string: decodedJwt.redirectUrl) else {
              signingCompletion(CashAppSigningResult.failed(reason: .invalidRedirectUrl))
              return
            }

            let cashAppData = CashAppSigningData(
              jwt: cashAppSigningResponse.jwtToken,
              amount: amount,
              redirectUri: redirectURL,
              merchantId: decodedJwt.externalMerchantId,
              brandId: cashAppSigningResponse.externalBrandId
            )

            signingCompletion(CashAppSigningResult.success(data: cashAppData))
            return
          } else {
            signingCompletion(CashAppSigningResult.failed(reason: .httpError(errorCode: httpResponse.statusCode)))
            return
          }
        }
      } catch is DecodingError {
        signingCompletion(CashAppSigningResult.failed(reason: .responseDecodeError))
      } catch {
        signingCompletion(CashAppSigningResult.failed(reason: .jwtDecodeError(error: error)))
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

  internal static func validateOrder(
    configuration: Configuration,
    jwt: String,
    customerId: String,
    grantId: String,
    completion: @escaping (CashAppValidationResult) -> Void
  ) {
    let requestBody: [String: Any] = [
      "jwt": jwt,
      "externalCustomerId": customerId,
      "externalGrantId": grantId,
    ]
    let jsonRequestBody = try? JSONSerialization.data(withJSONObject: requestBody)

    guard let request = CashAppPayCheckout.createRequest(
      urlString: configuration.environment.cashAppValidationURL,
      jsonRequestBody: jsonRequestBody
    ) else {
      return assertionFailure("Could not create signing request when handling CashApp token")
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
      if error != nil {
        completion(CashAppValidationResult.failed(reason: .error(error: error!)))
        return
      }

      do {
        if let data = data {
          let httpResponse = response as! HTTPURLResponse
          let decoder = JSONDecoder()

          if 200...299 ~= httpResponse.statusCode {
            let cashAppValidationResponse = try decoder.decode(CashAppValidationData.self, from: data)

            if cashAppValidationResponse.status == "SUCCESS" {
              completion(CashAppValidationResult.success(data: cashAppValidationResponse))
            } else {
              completion(CashAppValidationResult.failed(reason: .invalid))
            }
            return
          } else {
            let responseError = try JSONSerialization.jsonObject(with: data) as? [String: Any]
            completion(CashAppValidationResult.failed(
              reason: .httpError(
                errorCode: httpResponse.statusCode,
                message: responseError?["message"] as! String
              )
            ))
            return
          }
        } else {
          completion(CashAppValidationResult.failed(reason: .nilData))
          return
        }
      } catch is DecodingError {
        completion(CashAppValidationResult.failed(reason: .responseDecodeError))
      } catch {
        completion(CashAppValidationResult.failed(reason: .unknownError))
      }
    }.resume()
  }
}
