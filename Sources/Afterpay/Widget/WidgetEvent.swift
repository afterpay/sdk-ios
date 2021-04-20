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
  ///
  /// The checksum is optional. It is only provided if once you've sent the Widget a checkout token.
  case valid(amountDueToday: Money, checksum: String?)

  /// The widget is invalid, and checkout should not proceed
  ///
  /// Although the widget will inform the user of the errors on its own, they are also provided here for convenience
  /// if they are available.
  case invalid(errorCode: String?, message: String?)

  private enum CodingKeys: String, CodingKey {
    case isValid, amountDueToday, paymentScheduleChecksum, error
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    if try container.decode(Bool.self, forKey: .isValid) == true {
      let amountDue = try container.decode(Money.self, forKey: .amountDueToday)
      let checksum = try? container.decodeIfPresent(String.self, forKey: .paymentScheduleChecksum)

      self = .valid(amountDueToday: amountDue, checksum: checksum)
    } else {
      let error = try? container.decodeIfPresent(WidgetError.self, forKey: .error)
      self = .invalid(errorCode: error?.errorCode, message: error?.message)
    }
  }

}

private struct WidgetError: Codable {
  let errorCode: String
  let message: String
}

enum WidgetEvent: Decodable, Equatable {

  case ready(isValid: Bool, amountDue: Money, checksum: String?)
  case change(status: WidgetStatus)
  case error(errorCode: String?, message: String?)
  case resize(suggestedSize: Int?)

  private enum CodingKeys: String, CodingKey {
    case type, isValid, amountDueToday, paymentScheduleChecksum, error, size
  }

  private enum EventType: String, Decodable {
    case ready, change, error, resize
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
      let checksum = try? container.decodeIfPresent(String.self, forKey: .paymentScheduleChecksum)

      self = .ready(isValid: isValid, amountDue: amountDue, checksum: checksum)

    case .change:
      let valid = try container.decode(Bool.self, forKey: .isValid)

      let status: WidgetStatus

      if valid {
        let amountDue = try container.decode(Money.self, forKey: .amountDueToday)
        let checksum = try? container.decodeIfPresent(String.self, forKey: .paymentScheduleChecksum)

        status = .valid(amountDueToday: amountDue, checksum: checksum)
      } else {
        let error = try? container.decodeIfPresent(WidgetError.self, forKey: .error)

        status = .invalid(errorCode: error?.errorCode, message: error?.message)
      }

      self = .change(status: status)
    case .resize:
      let suggestedSize = try? container.decodeIfPresent(Int.self, forKey: .size)

      self = .resize(suggestedSize: suggestedSize)
    }
  }

}
