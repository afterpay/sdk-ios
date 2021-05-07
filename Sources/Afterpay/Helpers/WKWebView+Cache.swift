//
//  WKWebView+Cache.swift
//  Afterpay
//
//  Created by Huw Rowlands on 7/5/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import WebKit

extension WKWebView {

  /// Remove disk caches so that the latest bootstrap is loaded
  func removeCache(for displayName: String, completionHandler: @escaping () -> Void) {
    let dataStore = configuration.websiteDataStore
    let dataTypes: Set<String> = [WKWebsiteDataTypeDiskCache]

    dataStore.fetchDataRecords(ofTypes: dataTypes) { records in
      let bootstrapRecords = records.filter { record in record.displayName == displayName }
      dataStore.removeData(ofTypes: dataTypes, for: bootstrapRecords, completionHandler: completionHandler)
    }
  }

}
