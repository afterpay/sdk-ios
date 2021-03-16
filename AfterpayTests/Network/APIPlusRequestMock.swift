//
//  APIPlusRequestMock.swift
//  AfterpayTests
//
//  Created by Nabila Herzegovina on 3/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

@testable import Afterpay
import Foundation

struct APIPlusRequestMock {
  var endpoint: Endpoint
  var response: Data

  init(with scenario: APIPlusNetworkServiceTestScenario) {
    self.endpoint = .singleUseCards(.mock())
    self.response = SingleUseCardResponse.mock(scenario: scenario)
  }

  func getURL() -> URL? {
    var urlComponent = URLComponents(string: endpoint.baseURL())
    urlComponent?.path = endpoint.path

    return urlComponent?.url
  }
}
