//
//  WidgetEvent.swift
//  Afterpay
//
//  Created by Huw Rowlands on 11/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

public enum WidgetStatus: Decodable, Equatable {

  /// The widget is valid.
  ///
  /// In particular, this provides the amount due today, and the payment schedule checksum; both of which should be
  /// persisted on the merchant backend.
  case valid(amountDueToday: Money, checksum: String)

  /// The widget is invalid, and checkout should not proceed
  ///
  /// Although the widget will inform the user of the errors on its own, they are also provided here for convenience
  /// if they are available.
  case invalid(errorCode: String?, message: String?)

  private enum CodingKeys: String, CodingKey {
    case isValid, amountDueToday, paymentScheduleChecksum
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    if try container.decode(Bool.self, forKey: .isValid) == true {
      let amountDue = try container.decode(Money.self, forKey: .amountDueToday)
      let checksum = try container.decode(String.self, forKey: .paymentScheduleChecksum)

      self = .valid(amountDueToday: amountDue, checksum: checksum)
    } else {
      self = .invalid(errorCode: nil, message: nil)
    }
  }

}

enum WidgetEvent: Decodable, Equatable {

  case ready(isValid: Bool, amountDue: Money, checksum: String)
  case change(status: WidgetStatus)
  case error(errorCode: String?, message: String?)
  case resize

  private enum CodingKeys: String, CodingKey {
    case type, isValid, amountDueToday, paymentScheduleChecksum, error
  }

  private enum EventType: String, Decodable {
    case ready, change, error, resize
  }

  private struct WidgetError: Codable {
    let errorCode: String
    let message: String
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    let type = try container.decode(EventType.self, forKey: .type)

    switch type {
    case .error:
      let error = try? container.decodeIfPresent(WidgetError.self, forKey: .error)
      self = .error(errorCode: error?.errorCode, message: error?.message)

    case .ready:
      let isValid = try container.decode(Bool.self, forKey: .isValid)
      let amountDue = try container.decode(Money.self, forKey: .amountDueToday)
      let checksum = try container.decode(String.self, forKey: .paymentScheduleChecksum)

      self = .ready(isValid: isValid, amountDue: amountDue, checksum: checksum)

    case .change:
      let valid = try container.decode(Bool.self, forKey: .isValid)

      let status: WidgetStatus

      if valid {
        let amountDue = try container.decode(Money.self, forKey: .amountDueToday)
        let checksum = try container.decode(String.self, forKey: .paymentScheduleChecksum)

        status = .valid(amountDueToday: amountDue, checksum: checksum)
      } else {
        let error = try? container.decodeIfPresent(WidgetError.self, forKey: .error)

        status = .invalid(errorCode: error?.errorCode, message: error?.message)
      }

      self = .change(status: status)
    case .resize:
      self = .resize
    }
  }

}
