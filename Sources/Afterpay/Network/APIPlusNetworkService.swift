//
//  NetworkService.swift
//  Afterpay
//
//  Created by Nabila Herzegovina on 10/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

enum NetworkError: Error {
  case invalidUrl
  case failedToDecode(Data)
  case failedToEncode
}

final class APIPlusNetworkService {

  private let session: URLSession

  public static let shared = APIPlusNetworkService()

  init(with session: URLSession = URLSession(configuration: .default)) {
    self.session = session
  }

  func request<T: Decodable>(endpoint: Endpoint, mode: Mode, completion: @escaping (Result<T, Error>) -> Void) {

    var urlComponent = URLComponents(string: endpoint.baseURL())
    urlComponent?.path = endpoint.path

    guard let url = urlComponent?.url else {
      completion(.failure(NetworkError.invalidUrl))
      return
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = endpoint.method.rawValue

    if endpoint.method == .post {
      urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

      do {
        urlRequest.httpBody = try getRequestBody(for: endpoint)
      } catch {
        completion(.failure(error))
      }
    }

    session.dataTask(with: urlRequest) { data, _, error in
      if let data = data, error == nil {
        do {
          let response = try JSONDecoder().decode(T.self, from: data)
          completion(.success(response))
        } catch {
          do {
            let response = try JSONDecoder().decode(APIPlusErrorDetails.self, from: data)
            completion(.failure(APIPlusError.error(details: response)))
          } catch {
            completion(.failure(NetworkError.failedToDecode(data)))
          }
        }
      } else if let error = error {
        completion(.failure(error))
      }
    }.resume()
  }

  // Encode

  func encode<T>(_ payload: T) throws -> Data where T: Encodable {
    do {
      return try JSONEncoder().encode(payload)
    } catch {
      throw NetworkError.failedToEncode
    }
  }

  func getRequestBody(for endpoint: Endpoint) throws -> Data {
    switch endpoint {
    case .consumerCardConfirm(let payload):
      return try encode(payload)
    case .consumerCards(let payload):
      return try encode(payload)
    }
  }
}
