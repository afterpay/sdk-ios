//
//  Environment.swift
//  Example
//
//  Created by Ryan Davis on 5/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import SwiftUI

private struct RepositoryKey: EnvironmentKey {
  static let defaultValue: Repository = .shared
}

@available(iOS 13.0, *)
extension EnvironmentValues {
  var repository: Repository {
    self[RepositoryKey.self]
  }
}
