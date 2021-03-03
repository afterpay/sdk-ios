//
//  URLProtocolMock.swift
//  AfterpayTests
//
//  Created by Nabila Herzegovina on 3/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

final class URLProtocolMock: URLProtocol {
  static var testURLs = [URL?: Data]()

  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  override func startLoading() {
    if let url = request.url, let data = URLProtocolMock.testURLs[url] {
      client?.urlProtocol(self, didLoad: data)
    }

    client?.urlProtocolDidFinishLoading(self)
  }

  override func stopLoading() { }
}
