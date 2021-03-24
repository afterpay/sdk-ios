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

  /// HTTP request method without handling JSON response body
  /// - Parameters:
  ///   - endpoint: HTTP Request Endpoint
  ///   - mode: Environment mode that determines base URL value
  ///   - completion: The block executed after HTTP request has been completed.
  func request(endpoint: Endpoint, mode: Mode, completion: @escaping (Result<Data, Error>) -> Void) {
    do {
      let urlRequest = try makeUrlRequest(with: endpoint, mode: mode)

      session.dataTask(with: urlRequest) { data, response, error in
        if let data = data, let response = response as? HTTPURLResponse, error == nil {
          do {
            switch response.statusCode {
            case 200...299:
              completion(.success(data))
            default:
              let response = try JSONDecoder().decode(APIPlusErrorDetails.self, from: data)
              completion(.failure(APIPlusError.error(details: response)))
            }
          } catch {
            completion(.failure(NetworkError.failedToDecode(data)))
          }
        } else if let error = error {
          completion(.failure(error))
        }
      }.resume()
    } catch {
      completion(.failure(error))
    }
  }

  /// HTTP request generic method that handles JSON response body.
  /// The generic decodable type needs to be specified to decode JSON response body.
  /// - Parameters:
  ///   - endpoint: HTTP Request Endpoint
  ///   - mode: Environment mode that determines base URL value
  ///   - completion: The block executed after HTTP request has been completed.
  func request<T: Decodable>(endpoint: Endpoint, mode: Mode, completion: @escaping (Result<T, Error>) -> Void) {
    request(endpoint: endpoint, mode: mode) { result in
      result.fold(
        successTransform: { data in
          do {
            let response = try JSONDecoder().decode(T.self, from: data)
            completion(.success(response))
          } catch {
            completion(.failure(NetworkError.failedToDecode(data)))
          }
      }, errorTransform: { error in completion(.failure(error)) })
    }
  }

  private func makeUrlRequest(with endpoint: Endpoint, mode: Mode) throws -> URLRequest {
    var urlComponent = URLComponents(string: endpoint.baseURL(mode: mode))
    urlComponent?.path = endpoint.path

    guard let url = urlComponent?.url else {
      throw NetworkError.invalidUrl
    }

    var urlRequest = URLRequest(url: url)
    urlRequest.httpMethod = endpoint.method.rawValue

    if endpoint.method == .post {
      urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
      urlRequest.httpBody = try getRequestBody(for: endpoint)
    }

    return urlRequest
  }

  // MARK: - Encode

  private func encode<T>(_ payload: T) throws -> Data where T: Encodable {
    do {
      return try JSONEncoder().encode(payload)
    } catch {
      throw NetworkError.failedToEncode
    }
  }

  private func getRequestBody(for endpoint: Endpoint) throws -> Data {
    switch endpoint {
    case .singleUseCardConfirm(let payload):
      return try encode(payload)
    case .singleUseCards(let payload):
      return try encode(payload)
    case .singleUseCardCancel(let payload):
      return try encode(payload)
    }
  }
}
