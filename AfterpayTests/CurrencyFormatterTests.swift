//
//  CurrencyFormatterTests.swift
//  AfterpayTests
//
//  Created by Adam Campbell on 16/10/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

@testable import Afterpay
import XCTest

class CurrencyFormatterTests: XCTestCase {
  private let itIT = Locale(identifier: "it_IT")
  private let frFR = Locale(identifier: "fr_FR")
  private let esES = Locale(identifier: "es_ES")

  func testEnAuLocale() {
    let currencyFormatter = createCurrencyFormatters(clientLocale: Locales.enAU)

    XCTAssertEqual(currencyFormatter.aud.string(from: 120), "$120.00")
    XCTAssertEqual(currencyFormatter.cad.string(from: 120), "$120.00 CAD")
    XCTAssertEqual(currencyFormatter.gbp.string(from: 120), "£120.00")
    XCTAssertEqual(currencyFormatter.nzd.string(from: 120), "$120.00 NZD")
    XCTAssertEqual(currencyFormatter.usd.string(from: 120), "$120.00 USD")
  }

  func testEnCaLocale() {
    let currencyFormatter = createCurrencyFormatters(clientLocale: Locales.enCA)

    XCTAssertEqual(currencyFormatter.aud.string(from: 120), "$120.00 AUD")
    XCTAssertEqual(currencyFormatter.cad.string(from: 120), "$120.00")
    XCTAssertEqual(currencyFormatter.gbp.string(from: 120), "£120.00")
    XCTAssertEqual(currencyFormatter.nzd.string(from: 120), "$120.00 NZD")
    XCTAssertEqual(currencyFormatter.usd.string(from: 120), "$120.00 USD")
  }

  func testFrCaLocale() {
    let currencyFormatter = createCurrencyFormatters(clientLocale: Locales.frCA)

    XCTAssertEqual(currencyFormatter.aud.string(from: 120), "$120,00 AUD")
    XCTAssertEqual(currencyFormatter.cad.string(from: 120), "120,00 $")
    XCTAssertEqual(currencyFormatter.gbp.string(from: 120), "£120,00")
    XCTAssertEqual(currencyFormatter.nzd.string(from: 120), "$120,00 NZD")
    XCTAssertEqual(currencyFormatter.usd.string(from: 120), "$120,00 USD")
  }

  func testEnGbLocale() {
    let currencyFormatter = createCurrencyFormatters(clientLocale: Locales.enGB)

    XCTAssertEqual(currencyFormatter.aud.string(from: 120), "$120.00 AUD")
    XCTAssertEqual(currencyFormatter.cad.string(from: 120), "$120.00 CAD")
    XCTAssertEqual(currencyFormatter.gbp.string(from: 120), "£120.00")
    XCTAssertEqual(currencyFormatter.nzd.string(from: 120), "$120.00 NZD")
    XCTAssertEqual(currencyFormatter.usd.string(from: 120), "$120.00 USD")
  }

  func testEnNzLocale() {
    let currencyFormatter = createCurrencyFormatters(clientLocale: Locales.enNZ)

    XCTAssertEqual(currencyFormatter.aud.string(from: 120), "$120.00 AUD")
    XCTAssertEqual(currencyFormatter.cad.string(from: 120), "$120.00 CAD")
    XCTAssertEqual(currencyFormatter.gbp.string(from: 120), "£120.00")
    XCTAssertEqual(currencyFormatter.nzd.string(from: 120), "$120.00")
    XCTAssertEqual(currencyFormatter.usd.string(from: 120), "$120.00 USD")
  }

  func testEnUSLocale() {
    let currencyFormatter = createCurrencyFormatters(clientLocale: Locales.enUS)

    XCTAssertEqual(currencyFormatter.aud.string(from: 120), "A$120.00")
    XCTAssertEqual(currencyFormatter.cad.string(from: 120), "CA$120.00")
    XCTAssertEqual(currencyFormatter.gbp.string(from: 120), "£120.00")
    XCTAssertEqual(currencyFormatter.nzd.string(from: 120), "NZ$120.00")
    XCTAssertEqual(currencyFormatter.usd.string(from: 120), "$120.00")
  }

  func testItItLocale() {
    let currencyFormatter = createCurrencyFormatters(clientLocale: itIT)

    XCTAssertEqual(currencyFormatter.aud.string(from: 120), "$120,00 AUD")
    XCTAssertEqual(currencyFormatter.cad.string(from: 120), "$120,00 CAD")
    XCTAssertEqual(currencyFormatter.gbp.string(from: 120), "£120,00")
    XCTAssertEqual(currencyFormatter.nzd.string(from: 120), "$120,00 NZD")
    XCTAssertEqual(currencyFormatter.usd.string(from: 120), "$120,00 USD")
  }

  func testEsEsLocale() {
    let currencyFormatter = createCurrencyFormatters(clientLocale: esES)

    XCTAssertEqual(currencyFormatter.aud.string(from: 120), "$120,00 AUD")
    XCTAssertEqual(currencyFormatter.cad.string(from: 120), "$120,00 CAD")
    XCTAssertEqual(currencyFormatter.gbp.string(from: 120), "£120,00")
    XCTAssertEqual(currencyFormatter.nzd.string(from: 120), "$120,00 NZD")
    XCTAssertEqual(currencyFormatter.usd.string(from: 120), "$120,00 USD")
  }

  func createCurrencyFormatters(clientLocale: Locale) -> AllFormatters {
    let formatter: (Locale) -> CurrencyFormatter = { configLocale in
      CurrencyFormatter(locale: configLocale, currencyCode: configLocale.currencyCode!, clientLocale: clientLocale)
    }

    return AllFormatters(
      aud: formatter(Locales.enAU),
      cad: formatter(Locales.enCA),
      gbp: formatter(Locales.enGB),
      nzd: formatter(Locales.enNZ),
      usd: formatter(Locales.enUS)
    )
  }

  internal struct AllFormatters {
    let aud: CurrencyFormatter
    let cad: CurrencyFormatter
    let gbp: CurrencyFormatter
    let nzd: CurrencyFormatter
    let usd: CurrencyFormatter
  }

}
