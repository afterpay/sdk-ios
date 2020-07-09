//
//  Settings.swift
//  Example
//
//  Created by Adam Campbell on 22/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

enum Language: String, CaseIterable {
  case swift = "Swift"
  case objectiveC = "Objective-C"
}

struct Settings {
  @Setting("email", defaultValue: "email@example.com")
  static var email: String

  @Setting("host", defaultValue: "localhost")
  static var host: String

  @Setting("port", defaultValue: "3000")
  static var port: String

  @Setting("currencyCode", defaultValue: "AUD")
  static var currencyCode: String

  @Setting("language", defaultValue: .swift)
  static var language: Language
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

extension Setting where T: RawRepresentable, T.RawValue == String {
  init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
    self.init(
      key: key,
      defaultValue: defaultValue,
      userDefaults: userDefaults,
      adapter: UserDefaultsAdapter(
        get: { defaults, key in defaults.string(forKey: key).flatMap(T.init(rawValue:)) },
        set: { defaults, key, value in defaults.set(value.rawValue, forKey: key) }
      )
    )
  }
}

@propertyWrapper
@dynamicMemberLookup
struct TextSetting {
  let title: String
  private(set) var setting: Setting<String>

  init(_ title: String, setting: Setting<String>) {
    self.title = title
    self.setting = setting
  }

  subscript<Value>(dynamicMember keyPath: KeyPath<Setting<String>, Value>) -> Value {
    return setting[keyPath: keyPath]
  }

  var wrappedValue: String {
    get { setting.wrappedValue }
    set { setting.wrappedValue = newValue }
  }
}

@propertyWrapper
struct PickerSetting {
  private struct SettingAdapter {
    var get: () -> String
    var set: (String) -> Void
  }

  let title: String
  let options: [String]

  private let adapter: SettingAdapter

  private init(title: String, options: [String], adapter: SettingAdapter) {
    self.title = title
    self.options = options
    self.adapter = adapter
  }

  var wrappedValue: String {
    get { adapter.get() }
    set { adapter.set(newValue) }
  }
}

extension PickerSetting {
  init<T>(_ title: String, setting: Setting<T>) where T: RawRepresentable & CaseIterable, T.RawValue == String {
    var setting = setting
    self.init(
      title: title,
      options: T.allCases.map(\.rawValue),
      adapter: SettingAdapter(
        get: { setting.wrappedValue.rawValue },
        set: { rawNewValue in
          if let newValue = T(rawValue: rawNewValue) {
            setting.wrappedValue = newValue
          }
        }
      )
    )
  }
}

enum AppSetting {
  case text(TextSetting)
  case picker(PickerSetting)
}

extension AppSetting {
  static var allSettings: [AppSetting] {
    return [
      .text(TextSetting("Email", setting: Settings.$email)),
      .text(TextSetting("Host", setting: Settings.$host)),
      .text(TextSetting("Port", setting: Settings.$port)),
      .text(TextSetting("Currency Code", setting: Settings.$currencyCode)),
      .picker(PickerSetting("Language", setting: Settings.$language)),
    ]
  }
}
