//
//  ExpressCheckoutMessage.swift
//  Afterpay
//
//  Created by Adam Campbell on 4/12/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

struct ExpressCheckoutMessage: Decodable {
  let requestId: String
  let event: Event?

  enum Event {
    case shippingAddressDidChange(Address)
  }

  private enum CodingKeys: String, CodingKey {
    case type, meta, payload
  }

  private enum MetaCodingKeys: String, CodingKey {
    case requestId
  }

  private enum MessageType: String, Decodable {
    case onShippingAddressChange
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let metaContainer = try container.nestedContainer(keyedBy: MetaCodingKeys.self, forKey: .meta)

    requestId = try metaContainer.decode(String.self, forKey: .requestId)

    let type = try? container.decode(MessageType.self, forKey: .type)

    switch type {
    case .onShippingAddressChange:
      let address = try container.decode(Address.self, forKey: .payload)
      event = .shippingAddressDidChange(address)
    default:
      event = nil
    }
  }
}
