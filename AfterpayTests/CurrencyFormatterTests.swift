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
    let formatter: (String?) -> CurrencyFormatter = { currencyCode in
      CurrencyFormatter(locale: Locales.australia, currencyCode: currencyCode!)
    }

    let audFormatter = formatter(Locales.australia.currencyCode)
    let cadFormatter = formatter(Locales.canada.currencyCode)
    let gbpFormatter = formatter(Locales.greatBritain.currencyCode)
    let nzdFormatter = formatter(Locales.newZealand.currencyCode)
    let usdFormatter = formatter(Locales.unitedStates.currencyCode)

    XCTAssertEqual(audFormatter.string(from: 120), "$120.00")
    XCTAssertEqual(cadFormatter.string(from: 120), "$120.00 CAD")
    XCTAssertEqual(gbpFormatter.string(from: 120), "£120.00")
    XCTAssertEqual(nzdFormatter.string(from: 120), "$120.00 NZD")
    XCTAssertEqual(usdFormatter.string(from: 120), "$120.00 USD")
  }

  func testCanadaLocale() {
    let formatter: (String?) -> CurrencyFormatter = { currencyCode in
      CurrencyFormatter(locale: Locales.canada, currencyCode: currencyCode!)
    }

    let audFormatter = formatter(Locales.australia.currencyCode)
    let cadFormatter = formatter(Locales.canada.currencyCode)
    let gbpFormatter = formatter(Locales.greatBritain.currencyCode)
    let nzdFormatter = formatter(Locales.newZealand.currencyCode)
    let usdFormatter = formatter(Locales.unitedStates.currencyCode)

    XCTAssertEqual(audFormatter.string(from: 120), "$120.00 AUD")
    XCTAssertEqual(cadFormatter.string(from: 120), "$120.00")
    XCTAssertEqual(gbpFormatter.string(from: 120), "£120.00")
    XCTAssertEqual(nzdFormatter.string(from: 120), "$120.00 NZD")
    XCTAssertEqual(usdFormatter.string(from: 120), "$120.00 USD")
  }

  func testGreatBritainLocale() {
    let formatter: (String?) -> CurrencyFormatter = { currencyCode in
      CurrencyFormatter(locale: Locales.greatBritain, currencyCode: currencyCode!)
    }

    let audFormatter = formatter(Locales.australia.currencyCode)
    let cadFormatter = formatter(Locales.canada.currencyCode)
    let gbpFormatter = formatter(Locales.greatBritain.currencyCode)
    let nzdFormatter = formatter(Locales.newZealand.currencyCode)
    let usdFormatter = formatter(Locales.unitedStates.currencyCode)

    XCTAssertEqual(audFormatter.string(from: 120), "$120.00 AUD")
    XCTAssertEqual(cadFormatter.string(from: 120), "$120.00 CAD")
    XCTAssertEqual(gbpFormatter.string(from: 120), "£120.00")
    XCTAssertEqual(nzdFormatter.string(from: 120), "$120.00 NZD")
    XCTAssertEqual(usdFormatter.string(from: 120), "$120.00 USD")
  }

  func testNewZealandLocale() {
    let formatter: (String?) -> CurrencyFormatter = { currencyCode in
      CurrencyFormatter(locale: Locales.newZealand, currencyCode: currencyCode!)
    }

    let audFormatter = formatter(Locales.australia.currencyCode)
    let cadFormatter = formatter(Locales.canada.currencyCode)
    let gbpFormatter = formatter(Locales.greatBritain.currencyCode)
    let nzdFormatter = formatter(Locales.newZealand.currencyCode)
    let usdFormatter = formatter(Locales.unitedStates.currencyCode)

    XCTAssertEqual(audFormatter.string(from: 120), "$120.00 AUD")
    XCTAssertEqual(cadFormatter.string(from: 120), "$120.00 CAD")
    XCTAssertEqual(gbpFormatter.string(from: 120), "£120.00")
    XCTAssertEqual(nzdFormatter.string(from: 120), "$120.00")
    XCTAssertEqual(usdFormatter.string(from: 120), "$120.00 USD")
  }

  func testUnitedStatesLocale() {
    let formatter: (String?) -> CurrencyFormatter = { currencyCode in
      CurrencyFormatter(locale: Locales.unitedStates, currencyCode: currencyCode!)
    }

    let audFormatter = formatter(Locales.australia.currencyCode)
    let cadFormatter = formatter(Locales.canada.currencyCode)
    let gbpFormatter = formatter(Locales.greatBritain.currencyCode)
    let nzdFormatter = formatter(Locales.newZealand.currencyCode)
    let usdFormatter = formatter(Locales.unitedStates.currencyCode)

    XCTAssertEqual(audFormatter.string(from: 120), "A$120.00")
    XCTAssertEqual(cadFormatter.string(from: 120), "CA$120.00")
    XCTAssertEqual(gbpFormatter.string(from: 120), "£120.00")
    XCTAssertEqual(nzdFormatter.string(from: 120), "NZ$120.00")
    XCTAssertEqual(usdFormatter.string(from: 120), "$120.00")
  }

}
