//
//  Networking.swift
//  Example
//
//  Created by Adam Campbell on 15/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Combine
import Foundation

private let session = URLSession(configuration: .default)
private let baseUrlComponents = URLComponents(
  url: URL(string: "http://localhost:3000")!,
  resolvingAgainstBaseURL: true)!
private let checkoutsPath = "/checkouts"

private struct CheckoutsRequest: Encodable {
  let email: String
}

private struct CheckoutsResponse: Decodable {
  let url: URL
}

func checkout(with email: String) -> AnyPublisher<URL, Error> {
  var urlComponents = baseUrlComponents
  urlComponents.path = checkoutsPath

  var request = URLRequest(url: urlComponents.url!)
  request.httpMethod = "POST"
  request.httpBody = try? JSONEncoder().encode(CheckoutsRequest(email: email))
  request.setValue("application/json", forHTTPHeaderField: "Content-Type")

  return session
    .dataTaskPublisher(for: request)
    .tryMap { data, _ -> URL in
      let response = try JSONDecoder().decode(CheckoutsResponse.self, from: data)
      return response.url
    }
    .eraseToAnyPublisher()
}
