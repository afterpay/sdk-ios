//
//  Networking.swift
//  Example
//
//  Created by Adam Campbell on 15/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

private let session = URLSession(configuration: .default)
private let baseUrlComponents = URLComponents(
  url: URL(string: "http://localhost:3000")!,
  resolvingAgainstBaseURL: true)!
private let checkoutsPath = "/checkouts"

private struct CheckoutsRequest: Encodable {
  let email: String
  let amount: String
}

private struct CheckoutsResponse: Decodable {
  let url: URL
}

enum CheckoutError: Error {
  case malformedUrl
  case unknown
}

func checkout(
  with email: String,
  for amount: String,
  completion: @escaping (Result<URL, Error>) -> Void
) {
  let baseUrl = URL(string: "http://\(Settings.host):\(Settings.port)")
  var urlComponents = baseUrl.flatMap { URLComponents(url: $0, resolvingAgainstBaseURL: true) }
  urlComponents?.path = checkoutsPath

  guard let url = urlComponents?.url else {
    completion(.failure(CheckoutError.malformedUrl))
    return
  }

  var request = URLRequest(url: url)
  request.httpMethod = "POST"

  // A failed encoding operation here would represent programmer error
  // swiftlint:disable:next force_try
  request.httpBody = try! JSONEncoder().encode(CheckoutsRequest(email: email, amount: amount))
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")

  let task = session.dataTask(with: request) { data, _, error in
    guard error == nil, let data = data else {
      return completion(.failure(error ?? CheckoutError.unknown))
    }

    do {
      let response = try JSONDecoder().decode(CheckoutsResponse.self, from: data)
      completion(.success(response.url))
    } catch {
      completion(.failure(error))
    }
  }

  task.resume()
}
