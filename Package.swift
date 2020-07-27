// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Afterpay",
  platforms: [
    .iOS(.v12),
  ],
  products: [
    .library(name: "Afterpay", targets: ["Afterpay"]),
  ],
  dependencies: [
    .package(url: "https://github.com/exyte/Macaw.git", .branch("master"))
  ],
  targets: [
    .target(name: "Afterpay", dependencies: []),
    .testTarget(name: "AfterpayTests", dependencies: ["Afterpay"], path: "AfterpayTests"),
  ]
)
