//
//  APIPlusNetworkServiceTests.swift
//  AfterpayTests
//
//  Created by Nabila Herzegovina on 3/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

@testable import Afterpay
import XCTest

class APIPlusNetworkServiceTests: XCTestCase {

  func testSuccessWithResponse() {
    let testScenario = APIPlusNetworkServiceTestScenario.success
    let mockEndpoint = APIPlusRequestMock(with: testScenario)
    let networkService = createNetworkService(with: mockEndpoint)
    let expectedResponse = ConsumerCardResponse(
      consumerCardToken: "CC13851e16b3e24fb783f63d90bbed805c",
      token: "002.cr7v4knfeh38209sd2iu0btqlc87nkfogregdntsom1ghlk2",
      expires: "2021-03-03T07:31:53.553Z",
      redirectCheckoutUrl: URL(string: "https://www.apple.com")!)
    let networkExpectation = expectation(description: "Network")

    networkService.request(
      endpoint: mockEndpoint.endpoint,
      mode: .sandbox
    ) { (result: Result<ConsumerCardResponse, Error>) in
      switch result {
      case .success(let actualResponse):
        XCTAssertEqual(actualResponse, expectedResponse)
      case .failure(let error):
        XCTFail("Fail with \(error)")
      }

      networkExpectation.fulfill()
    }

    waitForExpectations(timeout: 5, handler: nil)
  }

  private func createNetworkService(with mockRequest: APIPlusRequestMock) -> APIPlusNetworkService {
    URLProtocolMock.testURLs = [mockRequest.getURL(): mockRequest.response]

    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [URLProtocolMock.self]

    let session = URLSession(configuration: config)

    return APIPlusNetworkService(with: session)
  }
}
