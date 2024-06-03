//
//  URLSessionMock.swift
//  AfterpayTests
//
//  Created by Mark Mroz on 2024-06-03.
//  Copyright © 2024 Afterpay. All rights reserved.
//

import Foundation

// MARK: - URLSessionDataTaskMock

final class URLSessionDataTaskMock: URLSessionDataTask {
  private let resumeHandler: () -> Void

  init(resumeHandler: @escaping () -> Void) {
    self.resumeHandler = resumeHandler
  }

  override func resume() {
    resumeHandler()
  }
}

// MARK: - URLSessionMock

final class URLSessionMock: URLSession {
  typealias RequestDataTaskHandler = (URLRequest) -> (Data?, URLResponse?, Error?)
  typealias URLDataTaskHandler = (URL) -> (Data?, URLResponse?, Error?)
  typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

  private let dataTaskHandler: URLDataTaskHandler
  private let requestDataTaskHandler: RequestDataTaskHandler

  init(
    dataTaskHandler: @escaping URLDataTaskHandler = { _ in (nil, nil, nil) },
    requestDataTaskHandler: @escaping RequestDataTaskHandler = { _ in (nil, nil, nil) }
  ) {
    self.dataTaskHandler = dataTaskHandler
    self.requestDataTaskHandler = requestDataTaskHandler
  }

  override func dataTask(
    with url: URL,
    completionHandler: @escaping CompletionHandler
  ) -> URLSessionDataTask {
    let (data, response, error) = dataTaskHandler(url)
    return URLSessionDataTaskMock {
      completionHandler(data, response, error)
    }
  }

  override func dataTask(
    with request: URLRequest,
    completionHandler: @escaping CompletionHandler
  ) -> URLSessionDataTask {
    let (data, response, error) = requestDataTaskHandler(request)
    return URLSessionDataTaskMock {
      completionHandler(data, response, error)
    }
  }
}
