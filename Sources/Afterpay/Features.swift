//
//  Features.swift
//  Afterpay
//
//  Created by Huw Rowlands on 11/3/21.
//  Copyright © 2021 Afterpay. All rights reserved.
//

import Foundation

/// Feature flags for the Afterpay SDK.
///
/// Afterpay SDK feature flags are driven by UserDefaults and launch arguments. When creating a feature flag, we create
/// a static property in here to read it. For a given key, the property reads the flag's status from UserDefaults:
///
/// ```
/// UserDefaults.standard.bool(forKey: "com.afterpay.example-key")
/// ```
///
/// Users of the SDK can specify the launch argument: `-com.afterpay.example-key YES` to turn on this feature flag (or
/// `-com.afterpay.example-key NO` to turn it off).
///
/// If this struct has no static properties, it means there are no features currently being flagged.
///
/// # See Also
/// * [SwiftLee](https://www.avanderlee.com/xcode/overriding-userdefaults-launch-arguments/) -
///   Overriding UserDefaults for improved productivity
public struct AfterpayFeatures {

}
