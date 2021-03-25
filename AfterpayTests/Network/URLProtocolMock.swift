//
//  URLProtocolMock.swift
//  AfterpayTests
//
//  Created by Nabila Herzegovina on 3/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

final class URLProtocolMock: URLProtocol {
  static var mockRequest: APIPlusRequestMock?

  override class func canInit(with request: URLRequest) -> Bool {
    return true
  }

  override class func canonicalRequest(for request: URLRequest) -> URLRequest {
    return request
  }

  override func startLoading() {
    if
      let url = request.url,
      let mockRequest = URLProtocolMock.mockRequest,
      let httpUrlResponse = HTTPURLResponse(
        url: url,
        statusCode: mockRequest.statusCode,
        httpVersion: nil,
        headerFields: nil
      ) {
      client?.urlProtocol(self, didReceive: httpUrlResponse, cacheStoragePolicy: .notAllowed)
      client?.urlProtocol(self, didLoad: mockRequest.response)
    }
    client?.urlProtocolDidFinishLoading(self)
  }

  override func stopLoading() { }
}
