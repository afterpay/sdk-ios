//
//  Result+Fold.swift
//  Afterpay
//
//  Created by Adam Campbell on 4/2/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

extension Result {
  func fold<T>(
    successTransform: (Success) -> T,
    errorTransform: (Failure) -> T
  ) -> T {
    switch self {
    case .success(let success):
      return successTransform(success)
    case .failure(let error):
      return errorTransform(error)
    }
  }
}
