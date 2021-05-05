//
//  CombineWrapper.swift
//  Afterpay
//
//  Created by Huw Rowlands on 29/4/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Combine

@available(iOS 13.0, *)
public class WidgetEventPublisher: WidgetHandler {

  public init() { }

  public typealias ReadyData = (isValid: Bool, amountDueToday: Money, paymentScheduleChecksum: String?)
  public typealias ErrorData = (errorCode: String?, message: String?)

  private let readySubject = PassthroughSubject<ReadyData, Never>()
  private let changedSubject = PassthroughSubject<WidgetStatus, Never>()
  private let errorsSubject = PassthroughSubject<ErrorData, Never>()
  private let failuresSubject = PassthroughSubject<Error, Never>()

  public var ready: AnyPublisher<ReadyData, Never> {
    readySubject.eraseToAnyPublisher()
  }

  public var changed: AnyPublisher<WidgetStatus, Never> {
    changedSubject.eraseToAnyPublisher()
  }

  public var errors: AnyPublisher<ErrorData, Never> {
    errorsSubject.eraseToAnyPublisher()
  }

  public var failures: AnyPublisher<Error, Never> {
    failuresSubject.eraseToAnyPublisher()
  }

  // MARK: WidgetHandler

  public func onReady(isValid: Bool, amountDueToday: Money, paymentScheduleChecksum: String?) {
    readySubject.send(
      (isValid: isValid, amountDueToday: amountDueToday, paymentScheduleChecksum: paymentScheduleChecksum)
    )
  }

  public func onChanged(status: WidgetStatus) {
    changedSubject.send(status)
  }

  public func onError(errorCode: String?, message: String?) {
    errorsSubject.send(
      (errorCode, message)
    )
  }

  public func onFailure(error: Error) {
    failuresSubject.send(error)
  }

}
