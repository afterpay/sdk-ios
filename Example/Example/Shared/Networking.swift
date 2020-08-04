//
//  Networking.swift
//  Example
//
//  Created by Adam Campbell on 15/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

private let session = URLSession(configuration: .default)

private struct CheckoutsRequest: Encodable {
  let email: String
  let amount: String
}

struct CheckoutsResponse: Decodable {
  let url: URL
}

struct ConfigurationResponse: Decodable {
  let minimumAmount: Money?
  let maximumAmount: Money

  struct Money: Decodable {
    let amount: String
    let currency: String
  }
}

enum NetworkError: Error {
  case malformedUrl
  case unknown
}

struct Networking {
  typealias Completion = (Result<Data, Error>) -> Void

  var configuration: (_ completion: @escaping Completion) -> Void
  var checkout: (_ email: String, _ amount: String, _ completion: @escaping Completion) -> Void
}

extension Networking {
  static let live = Self(
    configuration: { completion in
      do {
        session.fire(try /"configuration", completion: completion)
      } catch {
        completion(.failure(error))
      }
    },
    checkout: { email, amount, completion in
      do {
        var request = URLRequest(url: try /"checkouts")
        request.httpMethod = "POST"
        request.httpBody = try JSONEncoder().encode(CheckoutsRequest(email: email, amount: amount))
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        session.fire(request, completion: completion)
      } catch {
        completion(.failure(error))
      }
    }
  )
}

prefix operator /
private prefix func / (path: String) throws -> URL {
  let baseUrl = URL(string: "http://\(Settings.host):\(Settings.port)")
  var urlComponents = baseUrl.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: false) }
  urlComponents?.path = "/\(path)"

  guard let url = urlComponents?.url else {
    throw NetworkError.malformedUrl
  }

  return url
}

private extension URLSession {
  func fire(_ url: URL, completion: @escaping Networking.Completion) {
    fire(URLRequest(url: url), completion: completion)
  }

  func fire(_ request: URLRequest, completion: @escaping Networking.Completion) {
    dataTask(with: request) { data, _, error in
      if let data = data, error == nil {
        completion(.success(data))
      } else {
        completion(.failure(error ?? NetworkError.unknown))
      }
    }.resume()
  }
}
