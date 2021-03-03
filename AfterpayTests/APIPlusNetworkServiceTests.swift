//
//  APIPlusNetworkServiceTests.swift
//  AfterpayTests
//
//  Created by Nabila Herzegovina on 3/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

@testable import Afterpay
import XCTest

final class URLProtocolMock: URLProtocol {
  // Test data
  static var testURLs = [URL?: Data]()

  override func startLoading() {
    if let url = request.url, let data = URLProtocolMock.testURLs[url] {
      client?.urlProtocol(self, didLoad: data)
    }

    client?.urlProtocolDidFinishLoading(self)
  }
}


