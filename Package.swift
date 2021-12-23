// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Afterpay",
  defaultLocalization: "en",
  platforms: [
    .iOS(.v12),
  ],
  products: [
    .library(name: "Afterpay", targets: ["Afterpay"]),
  ],
  dependencies: [
    .package(url: "https://github.com/exyte/Macaw.git", from: "0.9.7"),
  ],
  targets: [
    .target(name: "Afterpay", dependencies: ["Macaw"]),
    .testTarget(name: "AfterpayTests", dependencies: ["Afterpay"], path: "AfterpayTests"),
  ]
)
