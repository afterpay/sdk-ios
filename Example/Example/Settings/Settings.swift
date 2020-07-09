//
//  Settings.swift
//  Example
//
//  Created by Adam Campbell on 22/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

struct Settings {
  @Setting("email", defaultValue: "email@example.com")
  static var email: String

  @Setting("host", defaultValue: "localhost")
  static var host: String

  @Setting("port", defaultValue: "3000")
  static var port: String

  @Setting("currencyCode", defaultValue: "AUD")
  static var currencyCode: String
}

@propertyWrapper
struct Setting<T> {
  private struct UserDefaultsAdapter {
    var get: (UserDefaults, _ key: String) -> T?
    var set: (UserDefaults, _ key: String, _ value: T) -> Void
  }

  let key: String
  let defaultValue: T
  let userDefaults: UserDefaults

  private let adapter: UserDefaultsAdapter

  private init(
    key: String,
    defaultValue: T,
    userDefaults: UserDefaults,
    adapter: UserDefaultsAdapter
  ) {
    self.key = key
    self.defaultValue = defaultValue
    self.userDefaults = userDefaults
    self.adapter = adapter
  }

  var projectedValue: Self { self }

  var wrappedValue: T {
    get { return adapter.get(userDefaults, key) ?? defaultValue }
    set { adapter.set(userDefaults, key, newValue) }
  }
}

extension Setting where T == String {
  init(_ key: String, defaultValue: String, userDefaults: UserDefaults = .standard) {
    self.init(
      key: key,
      defaultValue: defaultValue,
      userDefaults: userDefaults,
      adapter: UserDefaultsAdapter(
        get: { defaults, key in defaults.string(forKey: key) },
        set: { defaults, key, value in defaults.set(value, forKey: key) }
      )
    )
  }
}

@propertyWrapper
@dynamicMemberLookup
struct TextSetting {
  let title: String
  private(set) var setting: Setting<String>

  subscript<Value>(dynamicMember keyPath: KeyPath<Setting<String>, Value>) -> Value {
    return setting[keyPath: keyPath]
  }

  var wrappedValue: String {
    get { setting.wrappedValue }
    set { setting.wrappedValue = newValue }
  }
}

enum AppSetting {
  case text(TextSetting)
}

extension AppSetting {
  static var allSettings: [AppSetting] {
    return [
      .text(TextSetting(title: "Email", setting: Settings.$email)),
      .text(TextSetting(title: "Host", setting: Settings.$host)),
      .text(TextSetting(title: "Port", setting: Settings.$port)),
      .text(TextSetting(title: "Currency Code", setting: Settings.$currencyCode)),
    ]
  }
}
