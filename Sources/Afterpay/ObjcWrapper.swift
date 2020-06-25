//
//  ObjcWrapper.swift
//  Afterpay
//
//  Created by Adam Campbell on 25/6/20.
//  Copyright © 2020 Afterpay. All rights reserved.
//

import Foundation
import UIKit

@available(swift, obsoleted: 1.0, message: "This wrapper should only be used from Objective-C")
@objc public final class AfterpayObjc: NSObject {

  @objc public static func presentCheckout(viewController: UIViewController) {
    Afterpay.presentCheckout(
      over: viewController,
      loading: URL(string: "https://google.com.au")!,
      animated: true,
      presentationCompletion: nil,
      cancelHandler: nil,
      successHandler: { _ in }
    )
  }

}
