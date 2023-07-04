Pod::Spec.new do |spec|
  spec.name          = "Afterpay"
  spec.version       = ENV['LIB_VERSION'] || '1.0.0' # fallback to major version
  spec.summary       = "Afterpay iOS SDK"
  spec.description   = <<-DESC
    The Afterpay iOS SDK provides drop in UI Components for a smooth Afterpay integration.
  DESC
  spec.homepage      = "https://github.com/afterpay/sdk-ios"
  spec.license       = "Apache License, Version 2.0"
  spec.author        = "Afterpay"
  spec.platform      = :ios, "12.0"
  spec.ios.deployment_target  = "12.0"
  spec.pod_target_xcconfig = { 'PRODUCT_BUNDLE_IDENTIFIER': 'com.afterpay.Afterpay' }
  spec.source        = { :git => "https://github.com/afterpay/sdk-ios.git", :tag => "#{spec.version}" }
  spec.resource_bundles = { "Afterpay" => "Sources/Afterpay/**/*.{pdf,xcassets,json}" }
  spec.source_files  = "Sources/Afterpay/**/*.{plist,swift}"
  spec.swift_version = "5.2"
  spec.framework     = "UIKit"
end
