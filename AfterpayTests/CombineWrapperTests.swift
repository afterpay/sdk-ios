//
//  CombineWrapperTests.swift
//  AfterpayTests
//
//  Created by Huw Rowlands on 5/5/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Afterpay
import Combine
import XCTest

@available(iOS 13.0, *)
public class CombineWrapperTests: XCTestCase {

  private var cancellables = Set<AnyCancellable>()

  func testReady() {
    let readyReceived = expectation(description: "ready received")

    let eventPublisher = WidgetEventPublisher()

    eventPublisher.ready
      .sink(receiveValue: { _ in readyReceived.fulfill() })
      .store(in: &cancellables)

    eventPublisher
      .onReady(isValid: true, amountDueToday: Money(amount: "20", currency: "AUD"), paymentScheduleChecksum: nil)

    wait(for: [readyReceived], timeout: 1)
  }

  func testChanged() {
    let changedReceived = expectation(description: "changed received")

    let eventPublisher = WidgetEventPublisher()

    eventPublisher.changed
      .sink(receiveValue: { _ in changedReceived.fulfill() })
      .store(in: &cancellables)

    eventPublisher
      .onChanged(status: .valid(amountDueToday: Money(amount: "20", currency: "AUD"), checksum: nil))

    wait(for: [changedReceived], timeout: 1)
  }

  func testError() {
    let errorReceived = expectation(description: "error received")

    let eventPublisher = WidgetEventPublisher()

    eventPublisher.errors
      .sink(receiveValue: { _ in errorReceived.fulfill() })
      .store(in: &cancellables)

    eventPublisher
      .onError(errorCode: "123", message: "I am sad")

    wait(for: [errorReceived], timeout: 1)
  }

  func testFailure() {
    let failureReceived = expectation(description: "failure received")

    let eventPublisher = WidgetEventPublisher()

    eventPublisher.failures
      .sink(receiveValue: { _ in failureReceived.fulfill() })
      .store(in: &cancellables)

    eventPublisher
      .onFailure(error: WidgetView.WidgetError.noConfiguration)

    wait(for: [failureReceived], timeout: 1)
  }

}
