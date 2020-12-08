//
//  ExpressCheckoutMessage.swift
//  Afterpay
//
//  Created by Adam Campbell on 4/12/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

struct ExpressCheckoutMessage: Codable {

  var requestId: String
  var event: Event?

  enum Event {
    case shippingAddressDidChange(Address)
    case updateShippingOptions([ShippingOption])
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

  init(requestId: String, event: Event?) {
    self.requestId = requestId
    self.event = event
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

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    var metaContainer = container.nestedContainer(keyedBy: MetaCodingKeys.self, forKey: .meta)

    try metaContainer.encode(requestId, forKey: .requestId)

    switch event {
    case .updateShippingOptions(let shippingOptions):
      try container.encode(shippingOptions, forKey: .payload)
    default:
      break
    }
  }

}
