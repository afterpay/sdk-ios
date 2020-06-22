//
//  Settings.swift
//  Example
//
//  Created by Adam Campbell on 22/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

struct Settings {

  @UserDefault("email", defaultValue: "email@example.com")
  static var email: String

  @UserDefault("host", defaultValue: "localhost")
  static var host: String

  @UserDefault("port", defaultValue: "3000")
  static var port: String

}
