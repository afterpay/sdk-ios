//
//  CheckoutV2Message.swift
//  Afterpay
//
//  Created by Adam Campbell on 4/12/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation

struct CheckoutV2Message: Codable {

  var requestId: String
  var payload: Payload?

  enum Payload {
    case address(ShippingAddress)
    case errorMessage(String)
    case shippingOption(ShippingOption)
    case shippingOptionUpdate(ShippingOptionUpdate)
    case shippingOptions([ShippingOption])
  }

  private enum CodingKeys: String, CodingKey {
    case type, meta, payload, error
  }

  private enum MetaCodingKeys: String, CodingKey {
    case requestId
  }

  private enum MessageType: String, Decodable {
    case onMessage
    case onShippingAddressChange
    case onShippingOptionChange
  }

  private struct OnMessage: Decodable {
    var severity: String
    var message: String
  }

  init(requestId: String, payload: Payload?) {
    self.requestId = requestId
    self.payload = payload
  }

  init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let metaContainer = try container.nestedContainer(keyedBy: MetaCodingKeys.self, forKey: .meta)

    requestId = try metaContainer.decode(String.self, forKey: .requestId)

    let type = try? container.decode(MessageType.self, forKey: .type)

    switch type {
    case .onShippingAddressChange:
      let address = try container.decode(ShippingAddress.self, forKey: .payload)
      payload = .address(address)
    case .onShippingOptionChange:
      let shippingOption = try container.decode(ShippingOption.self, forKey: .payload)
      payload = .shippingOption(shippingOption)
    case .onMessage:
      let onMessage = try container.decode(OnMessage.self, forKey: .payload)
      payload = .errorMessage("\(onMessage.severity.capitalized): \(onMessage.message)")
    default:
      payload = nil
    }
  }

  func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    var metaContainer = container.nestedContainer(keyedBy: MetaCodingKeys.self, forKey: .meta)

    try metaContainer.encode(requestId, forKey: .requestId)

    switch payload {
    case .shippingOptions(let shippingOptions):
      try container.encode(shippingOptions, forKey: .payload)
    case .shippingOption(let shippingOption):
      try container.encode(shippingOption, forKey: .payload)
    case .shippingOptionUpdate(let shippingOptionUpdate):
      try container.encode(shippingOptionUpdate, forKey: .payload)
    case .errorMessage(let errorMessage):
      // This is asymmetric with decode, errors are encoded as their own key/value pair when sent
      // not as the payload
      try container.encode(errorMessage, forKey: .error)
    default:
      break
    }
  }

}
