//
//  PriceBreakdownView.swift
//  Afterpay
//
//  Created by Adam Campbell on 3/8/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

public final class PriceBreakdownView: UIView {

  private let label = UILabel()

  public init() {
    super.init(frame: .zero)
  }

  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }

}
