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

// Inspired by: https://www.avanderlee.com/swift/property-wrappers/
@propertyWrapper
struct Setting {
  let key: String
  let defaultValue: String
  let title: String

  init(_ key: String, defaultValue: String, title: String) {
    self.key = key
    self.defaultValue = defaultValue
    self.title = title
  }

  var projectedValue: Setting { self }

  var wrappedValue: String {
    get {
      return UserDefaults.standard.string(forKey: key) ?? defaultValue
    }
    set {
      UserDefaults.standard.set(newValue, forKey: key)
    }
  }
}
