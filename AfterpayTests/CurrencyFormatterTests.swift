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

  func testAustraliaLocale() {
    let localeFormatter = createLocaleFormatters(clientLocale: Locales.enAU)

    XCTAssertEqual(localeFormatter.aud.string(from: 120), "$120.00")
    XCTAssertEqual(localeFormatter.cad.string(from: 120), "$120.00 CAD")
    XCTAssertEqual(localeFormatter.gbp.string(from: 120), "£120.00")
    XCTAssertEqual(localeFormatter.nzd.string(from: 120), "$120.00 NZD")
    XCTAssertEqual(localeFormatter.usd.string(from: 120), "$120.00 USD")
  }

  func testCanadaLocale() {
    let localeFormatter = createLocaleFormatters(clientLocale: Locales.enCA)

    XCTAssertEqual(localeFormatter.aud.string(from: 120), "$120.00 AUD")
    XCTAssertEqual(localeFormatter.cad.string(from: 120), "$120.00")
    XCTAssertEqual(localeFormatter.gbp.string(from: 120), "£120.00")
    XCTAssertEqual(localeFormatter.nzd.string(from: 120), "$120.00 NZD")
    XCTAssertEqual(localeFormatter.usd.string(from: 120), "$120.00 USD")
  }

  func testFrenchCanadaLocale() {
    let localeFormatter = createLocaleFormatters(clientLocale: Locales.frCA)

    XCTAssertEqual(localeFormatter.aud.string(from: 120), "$120,00 AUD")
    XCTAssertEqual(localeFormatter.cad.string(from: 120), "120,00 $")
    XCTAssertEqual(localeFormatter.gbp.string(from: 120), "£120,00")
    XCTAssertEqual(localeFormatter.nzd.string(from: 120), "$120,00 NZD")
    XCTAssertEqual(localeFormatter.usd.string(from: 120), "$120,00 USD")
  }

  func testGreatBritainLocale() {
    let localeFormatter = createLocaleFormatters(clientLocale: Locales.enGB)

    XCTAssertEqual(localeFormatter.aud.string(from: 120), "$120.00 AUD")
    XCTAssertEqual(localeFormatter.cad.string(from: 120), "$120.00 CAD")
    XCTAssertEqual(localeFormatter.gbp.string(from: 120), "£120.00")
    XCTAssertEqual(localeFormatter.nzd.string(from: 120), "$120.00 NZD")
    XCTAssertEqual(localeFormatter.usd.string(from: 120), "$120.00 USD")
  }

  func testNewZealandLocale() {
    let localeFormatter = createLocaleFormatters(clientLocale: Locales.enNZ)

    XCTAssertEqual(localeFormatter.aud.string(from: 120), "$120.00 AUD")
    XCTAssertEqual(localeFormatter.cad.string(from: 120), "$120.00 CAD")
    XCTAssertEqual(localeFormatter.gbp.string(from: 120), "£120.00")
    XCTAssertEqual(localeFormatter.nzd.string(from: 120), "$120.00")
    XCTAssertEqual(localeFormatter.usd.string(from: 120), "$120.00 USD")
  }

  func testUnitedStatesLocale() {
    let localeFormatter = createLocaleFormatters(clientLocale: Locales.enUS)

    XCTAssertEqual(localeFormatter.aud.string(from: 120), "A$120.00")
    XCTAssertEqual(localeFormatter.cad.string(from: 120), "CA$120.00")
    XCTAssertEqual(localeFormatter.gbp.string(from: 120), "£120.00")
    XCTAssertEqual(localeFormatter.nzd.string(from: 120), "NZ$120.00")
    XCTAssertEqual(localeFormatter.usd.string(from: 120), "$120.00")
  }

  func createLocaleFormatters(clientLocale: Locale) -> AllFormatters {
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
