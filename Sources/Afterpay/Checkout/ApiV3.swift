//
//  ApiV3.swift
//  Afterpay
//
//  Created by Chris Kolbu on 14/7/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public typealias URLRequestHandler = (URLRequest, @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask

enum ApiV3 {

  private static let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    let formatter = ISO8601DateFormatter()

    formatter.timeZone = TimeZone(abbreviation: "GMT")
    formatter.formatOptions = [
      .withInternetDateTime,
      .withDashSeparatorInDate,
      .withColonSeparatorInTime,
      .withTimeZone,
      .withFractionalSeconds,
    ]
    decoder.dateDecodingStrategy = .custom { decoder in
      let container = try decoder.singleValueContainer()
      let string = try container.decode(String.self)
      guard
        string.isEmpty == false,
        let date = formatter.date(from: string)
      else {
        throw DecodingError.dataCorruptedError(
          in: container,
          debugDescription: "Could not create Date from `\(string)`"
        )
      }
      return date
    }
    return decoder
  }()

  static func request(from url: URL) -> URLRequest {
    var request = URLRequest(url: url)
    request.setValue(Version.sdkVersion, forHTTPHeaderField: "X-Afterpay-SDK")
    return request
  }

  static func request<ReturnType: Decodable>(
    _ requestHandler: URLRequestHandler,
    _ request: URLRequest,
    type: ReturnType.Type,
    completion: @escaping (Result<ReturnType, Error>) -> Void
  ) -> URLSessionDataTask {
    let completeOnMainThread: (Result<ReturnType, Error>) -> Void = { result in
      DispatchQueue.main.async {
        completion(result)
      }
    }
    return requestHandler(request) { data, urlResponse, error in
      if error == nil, let data = data {
        if let error = try? Self.decoder.decode(ApiError.self, from: data) {
          completeOnMainThread(.failure(error))
          return
        }
        do {
          let parsed = try Self.decoder.decode(ReturnType.self, from: data)
          completeOnMainThread(.success(parsed))
        } catch {
          completeOnMainThread(.failure(error))
        }
      } else if let error = error {
        completeOnMainThread(.failure(error))
      } else {
        completeOnMainThread(.failure(NetworkError.unknown(urlResponse)))
      }
    }
  }

  public enum NetworkError: Error {
    case unknown(URLResponse?)
  }

}

public struct ApiError: Decodable, LocalizedError {

  let errorCode: String
  let errorId: String
  let message: String
  let httpStatusCode: Int

  public var failureReason: String? {
    message
  }

}
