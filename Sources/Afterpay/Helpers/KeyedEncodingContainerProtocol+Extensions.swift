//
//  KeyedEncodingContainerProtocol+Extensions.swift
//  AfterpayTests
//
//  Created by Mark Mroz on 2024-06-16.
//  Copyright © 2024 Afterpay. All rights reserved.
//

import Foundation

extension KeyedEncodingContainer {
  /// Encode the given value if it is true otherwise do nothing.
  mutating func encodeIfTrue(_ value: Bool, forKey key: Key) throws {
    guard value else { return }
    try encode(value, forKey: key)
  }
}
