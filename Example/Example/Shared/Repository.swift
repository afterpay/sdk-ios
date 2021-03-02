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

  private let locale = Locale(identifier: "en_US")
  private let environment = Environment.sandbox

  static let shared = Repository(apiClient: .live, userDefaults: .standard, now: Date.init)

  private var fallbackConfiguration: Configuration {
    // swiftlint:disable:next force_try
    try! Configuration(
      minimumAmount: nil,
      maximumAmount: "1000.00",
      currencyCode: "USD",
      locale: locale,
      environment: environment
    )
  }

  private(set) var configuration: Configuration {
    get {
      cachedConfiguration ?? fallbackConfiguration
    }
    set {
      DispatchQueue.main.async {
        Afterpay.setConfiguration(newValue)
      }
    }
  }

  private var cachedConfiguration: Configuration? {
    let response = userDefaults.configuration
      .flatMap { try? JSONDecoder().decode(ConfigurationResponse.self, from: $0) }

    let configuration = response.flatMap(self.configuration(response:))

    return try? configuration?.get()
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

  func fetchConfiguration(forceRefresh: Bool) {
    getConfigurationResponse(forceRefresh) { result in
      let configurationResult = result.flatMap(self.configuration(response:))

      if case .success(let fetchedConfig) = configurationResult, case .success(let response) = result {
        self.userDefaults.configuration = try? JSONEncoder().encode(response)
        self.userDefaults.lastFetchDate = self.now()

        self.configuration = fetchedConfig
      }

    }
  }

  private func getConfigurationResponse(
    _ forceRefresh: Bool,
    completion: @escaping (Result<ConfigurationResponse, Error>) -> Void
  ) {
    let responseFromData = { data in
      Result { try JSONDecoder().decode(ConfigurationResponse.self, from: data) }
    }

    if let configuration = userDefaults.configuration, shouldUseCachedConfiguration, forceRefresh == false {
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

  private func configuration(response: ConfigurationResponse) -> Result<Configuration, Error> {
    Result {
      try Configuration(
        minimumAmount: response.minimumAmount?.amount,
        maximumAmount: response.maximumAmount.amount,
        currencyCode: response.maximumAmount.currency,
        locale: Locale(identifier: response.locale),
        environment: environment
      )
    }
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
