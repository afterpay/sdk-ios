#
#  Be sure to run `pod spec lint Afterpay.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  spec.name         = "Afterpay"
  spec.version      = "0.0.1"
  spec.summary      = "Afterpay iOS SDK"
  spec.description  = <<-DESC
    The Afterpay iOS SDK provides drop in UI Components for a smooth Afterpay integration.
  DESC
  spec.homepage     = "https://github.com/afterpay/sdk-ios"
  spec.license      = "Apache License, Version 2.0"
  spec.author       = "Afterpay"
  spec.platform     = :ios, "12.0"
  spec.source       = { :git => "https://github.com/afterpay/sdk-ios.git", :tag => "#{spec.version}" }
  spec.source_files = "Sources"
  spec.framework    = "UIKit"
end
