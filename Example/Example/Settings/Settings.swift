//
//  Settings.swift
//  Example
//
//  Created by Adam Campbell on 22/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

struct Settings {
  @Setting("email", defaultValue: "email@example.com", title: "Email")
  static var email: String

  @Setting("host", defaultValue: "localhost", title: "Host")
  static var host: String

  @Setting("port", defaultValue: "3000", title: "Port")
  static var port: String
}

@propertyWrapper
struct Setting<T> {
  private struct UserDefaultsAdapter {
    var get: (UserDefaults, _ key: String) -> T?
    var set: (UserDefaults, _ key: String, _ value: T) -> Void
  }

  let key: String
  let defaultValue: T
  let title: String
  let userDefaults: UserDefaults

  private let adapter: UserDefaultsAdapter

  private init(
    key: String,
    defaultValue: T,
    title: String,
    userDefaults: UserDefaults,
    adapter: UserDefaultsAdapter
  ) {
    self.key = key
    self.defaultValue = defaultValue
    self.title = title
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
  init(_ key: String, defaultValue: String, title: String, userDefaults: UserDefaults = .standard) {
    self.init(
      key: key,
      defaultValue: defaultValue,
      title: title,
      userDefaults: userDefaults,
      adapter: UserDefaultsAdapter(
        get: { defaults, key in defaults.string(forKey: key) },
        set: { defaults, key, value in
          defaults.set(value.isEmpty ? nil : value, forKey: key)
        }
      )
    )
  }
}

extension Setting where T: RawRepresentable, T.RawValue == Int {
  init(_ key: String, defaultValue: T, title: String, userDefaults: UserDefaults = .standard) {
    self.init(
      key: key,
      defaultValue: defaultValue,
      title: title,
      userDefaults: userDefaults,
      adapter: UserDefaultsAdapter(
        get: { defaults, key in
          guard defaults.object(forKey: key) != nil else {
            return nil
          }
          return T(rawValue: defaults.integer(forKey: key))
        },
        set: { defaults, key, value in defaults.set(value.rawValue, forKey: key) }
      )
    )
  }
}

protocol SelectableSetting: RawRepresentable, CaseIterable where RawValue == Int {
  var label: String { get }
}

@propertyWrapper
struct PickerSetting {
  private struct SettingAdapter {
    var get: () -> Int
    var set: (Int) -> Void
  }

  let title: String
  let options: [String]

  private let adapter: SettingAdapter

  private init(title: String, options: [String], adapter: SettingAdapter) {
    self.title = title
    self.options = options
    self.adapter = adapter
  }

  var wrappedValue: Int {
    get { adapter.get() }
    set { adapter.set(newValue) }
  }
}

extension PickerSetting {
  init<T>(_ setting: Setting<T>) where T: SelectableSetting {
    var setting = setting
    self.init(
      title: setting.title,
      options: T.allCases.map(\.label),
      adapter: SettingAdapter(
        get: { setting.wrappedValue.rawValue },
        set: { rawValue in
          if let value = T(rawValue: rawValue) {
            setting.wrappedValue = value
          }
        }
      )
    )
  }
}

enum AppSetting {
  case text(Setting<String>)
  case picker(PickerSetting)
}

extension AppSetting {
  static var allSettings: [AppSetting] {
    return [
      .text(Settings.$email),
      .text(Settings.$host),
      .text(Settings.$port),
    ]
  }
}
