//
//  APIClient.swift
//  Example
//
//  Created by Adam Campbell on 15/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

private let session = URLSession(configuration: .default)

enum CheckoutMode: Equatable {
  case v1
  case v2
}

private struct CheckoutsRequest: Encodable {
  let email: String
  let amount: String
  let mode: String?
  let isCashAppPay: Bool

  init(email: String, amount: String, checkoutMode: CheckoutMode, isCashApp: Bool = false) {
    self.email = email
    self.amount = amount
    self.mode = checkoutMode == .v2 ? "express" : nil
    self.isCashAppPay = isCashApp
  }
}

struct CheckoutsResponse: Decodable {
  let token: String
  let url: URL
}

struct ConfigurationResponse: Codable {
  let minimumAmount: Money?
  let maximumAmount: Money
  let locale: LocaleResponse

  struct LocaleResponse: Codable {
    let identifier: String
  }

  struct Money: Codable {
    let amount: String
    let currency: String
  }
}

enum NetworkError: Error {
  case malformedUrl
  case unknown
}

struct APIClient {
  typealias Completion = (Result<Data, Error>) -> Void

  var configuration: (_ completion: @escaping Completion) -> Void
  var checkout: (
    _ email: String,
    _ amount: String,
    _ checkoutMode: CheckoutMode,
    _ isCashAppPay: Bool,
    _ completion: @escaping Completion
  ) -> Void
}

extension APIClient {
  static let live = Self(
    configuration: { completion in
      session.request(.configuration, completion: completion)
    },
    checkout: { email, amount, checkoutMode, isCashAppPay, completion in
      session.request(
        .checkout(
          email: email,
          amount: amount,
          checkoutMode: checkoutMode,
          isCashAppPay: isCashAppPay
        ),
        completion: completion
      )
    }
  )
}

private enum Endpoint {
  case configuration
  case checkout(email: String, amount: String, checkoutMode: CheckoutMode, isCashAppPay: Bool = false)

  var request: URLRequest? {
    switch self {
    case .configuration:
      return makeRequest("/configuration")
    case let .checkout(email, amount, checkoutMode, isCashApp):
      return makeRequest("/checkouts") { request in
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        // A failed encoding operation here would represent programmer error
        // swiftlint:disable:next force_try
        request.httpBody = try! JSONEncoder().encode(
          CheckoutsRequest(email: email, amount: amount, checkoutMode: checkoutMode, isCashApp: isCashApp)
        )
      }
    }
  }

  private func makeRequest(
    _ path: String,
    configure: ((inout URLRequest) -> Void)? = nil
  ) -> URLRequest? {
    let baseUrl = URL(string: "http://\(Settings.host):\(Settings.port)")
    var urlComponents = baseUrl.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false) }
    urlComponents?.path = path

    guard let url = urlComponents?.url else {
      return nil
    }

    var request = URLRequest(url: url)
    configure?(&request)
    return request
  }
}

private extension URLSession {
  func request(_ endpoint: Endpoint, completion: @escaping APIClient.Completion) {
    guard let request = endpoint.request else {
      completion(.failure(NetworkError.malformedUrl))
      return
    }

    dataTask(with: request) { data, _, error in
      if let data = data, error == nil {
        completion(.success(data))
      } else {
        completion(.failure(error ?? NetworkError.unknown))
      }
    }.resume()
  }
}
