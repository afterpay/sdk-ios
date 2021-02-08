//
//  Repository.swift
//  Example
//
//  Created by Ryan Davis on 4/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Afterpay
import Foundation
import os.log

final class Repository {
  private let apiClient: APIClient
  private let userDefaults: UserDefaults
  private let now: () -> Date

  static let shared = Repository(apiClient: .live, userDefaults: .standard, now: Date.init)

  var fallbackConfiguration: Configuration {
    let response = userDefaults.configuration.flatMap {
      try? JSONDecoder().decode(ConfigurationResponse.self, from: $0)
    }

    // Cached or fallback configuration
    guard let configuration = try? Configuration(
      minimumAmount: response?.minimumAmount?.amount ?? nil,
      maximumAmount: response?.maximumAmount.amount ?? "1000.00",
      currencyCode: response?.maximumAmount.currency ?? "USD",
      locale: Locale(identifier: "en_US"),
      environment: .sandbox
    ) else {
      preconditionFailure("Malformed cached or fallback configuration")
    }

    return configuration
  }

  init(apiClient: APIClient, userDefaults: UserDefaults, now: @escaping () -> Date) {
    self.apiClient = apiClient
    self.userDefaults = userDefaults
    self.now = now
  }

  func checkout(
    email: String,
    amount: String,
    completion: @escaping (Result<CheckoutsResponse, Error>) -> Void
  ) {
    apiClient.checkout(email, amount) { result in
      completion(result.flatMap { data in
        Result { try JSONDecoder().decode(CheckoutsResponse.self, from: data) }
      })
    }
  }

  func fetchConfiguration(completion: @escaping (Result<Configuration, Error>) -> Void) {
    getConfigurationResponse { result in
      let configurationResult = result.flatMap { response in
        Result {
          try Configuration(
            minimumAmount: response.minimumAmount?.amount,
            maximumAmount: response.maximumAmount.amount,
            currencyCode: response.maximumAmount.currency,
            locale: Locale(identifier: "en_US"),
            environment: .sandbox
          )
        }
      }

      if case .success = configurationResult, case .success(let response) = result {
        self.userDefaults.configuration = try? JSONEncoder().encode(response)
        self.userDefaults.lastFetchDate = self.now()
      }

      completion(configurationResult)
    }
  }

  private func getConfigurationResponse(
    completion: @escaping (Result<ConfigurationResponse, Error>) -> Void
  ) {
    let responseFromData = { data in
      Result { try JSONDecoder().decode(ConfigurationResponse.self, from: data) }
    }

    if Settings.config == .stub, let responseData = configurationStub.responseData {
      completion(responseFromData(responseData))
    } else if let configuration = userDefaults.configuration, shouldUseCachedConfiguration {
      completion(responseFromData(configuration))
    } else {
      apiClient.configuration { result in
        completion(result.flatMap(responseFromData))
      }
    }
  }

  private var shouldUseCachedConfiguration: Bool {
    guard let fetchDate = userDefaults.lastFetchDate else {
      return false
    }
    return now().timeIntervalSince(fetchDate) < .oneDay
  }
}

private extension UserDefaults {
  var configuration: Data? {
    get { data(forKey: #function) }
    set { set(newValue, forKey: #function) }
  }

  var lastFetchDate: Date? {
    get { object(forKey: #function) as? Date }
    set { set(newValue, forKey: #function) }
  }
}

private extension TimeInterval {
  static var oneDay: Self { 60 * 60 * 24 }
}
