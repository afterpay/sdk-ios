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
    let mockRequest = APIPlusRequestMock(with: testScenario)
    let networkService = createNetworkService(with: mockRequest)
    let networkExpectation = expectation(description: "Network")

    let expectedResponse = SingleUseCardCreateResponse(
      consumerCardToken: "CC13851e16b3e24fb783f63d90bbed805c",
      token: "002.cr7v4knfeh38209sd2iu0btqlc87nkfogregdntsom1ghlk2",
      expires: "2021-03-03T07:31:53.553Z",
      redirectCheckoutUrl: URL(string: "https://www.apple.com")!)

    networkService.request(
      endpoint: mockRequest.endpoint,
      mode: .sandbox
    ) { (result: Result<SingleUseCardCreateResponse, Error>) in
      switch result {
      case .success(let actualResponse):
        XCTAssertEqual(actualResponse, expectedResponse)
      case .failure(let error):
        XCTFail("Request should succeed and not fail with: \(error)")
      }

      networkExpectation.fulfill()
    }

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testFailureWithAPIError() {
    let testScenario = APIPlusNetworkServiceTestScenario.apiError
    let mockRequest = APIPlusRequestMock(with: testScenario)
    let networkService = createNetworkService(with: mockRequest)
    let networkExpectation = expectation(description: "Network")

    let expectedResponse = APIPlusErrorDetails(
      errorCode: "Precondition Failed",
      errorId: "44b1f24a5f9e48f1bc53738341314143",
      message: "Order 100101370360 is voided, expired or older than 25 days.",
      httpStatusCode: 412
    )

    networkService.request(
      endpoint: mockRequest.endpoint,
      mode: .sandbox
    ) { (result: Result<SingleUseCardCreateResponse, Error>) in
      switch result {
      case .success:
        XCTFail("Request should not succeed")

      case .failure(let error):
        if let error = error as? APIPlusError, case .error(let errorDetail) = error {
          XCTAssertEqual(errorDetail, expectedResponse)
        } else {
          XCTFail("Request should not fail with \(error)")
        }
      }

      networkExpectation.fulfill()
    }

    waitForExpectations(timeout: 5, handler: nil)
  }

  func testFailureWithDecodeError() {
    let testScenario = APIPlusNetworkServiceTestScenario.decodeError
    let mockRequest = APIPlusRequestMock(with: testScenario)
    let networkService = createNetworkService(with: mockRequest)
    let networkExpectation = expectation(description: "Network")

    networkService.request(
      endpoint: mockRequest.endpoint,
      mode: .sandbox
    ) { (result: Result<SingleUseCardCreateResponse, Error>) in
      switch result {
      case .success:
        XCTFail("Request should not succeed")

      case .failure(let error):
        guard let networkError = error as? NetworkError, case .failedToDecode = networkError else {
          XCTFail("Request should not fail with \(error)")
          networkExpectation.fulfill()
          return
        }
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
