//
//  Configuration.swift
//  Example
//
//  Created by Ryan Davis on 4/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import os.log

private extension TimeInterval {
  static var oneDay: Self { 60 * 60 * 24 }
}

private enum UserDefaultsKey {
  static var configuration: String { #function }
  static var lastFetchDate: String { #function }
}

func getCachedConfiguration(
  userDefaults: UserDefaults = .standard,
  now: @escaping () -> Date = Date.init,
  completion: @escaping (Result<ConfigurationResponse, Error>) -> Void
) {
  if
    let configuration = userDefaults.data(forKey: UserDefaultsKey.configuration),
    let lastFetchDate = userDefaults.object(forKey: UserDefaultsKey.lastFetchDate) as? Date,
    lastFetchDate.addingTimeInterval(.oneDay) > now()
  {
    do {
      let configuration = try JSONDecoder().decode(ConfigurationResponse.self, from: configuration)
      completion(.success(configuration))
      return
    } catch {
      os_log(.error, "Failed to retrieve cached configuration: %{public}@", error.localizedDescription)
      userDefaults.removeObject(forKey: UserDefaultsKey.configuration)
    }
  }

  getConfiguration { result in
    if case .success(let response) = result {
      do {
        let data = try JSONEncoder().encode(response)
        userDefaults.set(data, forKey: UserDefaultsKey.configuration)
        userDefaults.set(now(), forKey: UserDefaultsKey.lastFetchDate)
      } catch {
        os_log(.error, "Failed to cache configuration: %{public}@", error.localizedDescription)
      }
    }
    completion(result)
  }
}
