// swift-tools-version:5.3
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
  targets: [
    .target(name: "Afterpay"),
    .testTarget(
      name: "AfterpayTests",
      dependencies: ["Afterpay"],
      path: "AfterpayTests",
      exclude: [ "Info.plist" ],
      resources: [ .copy("mock-widget-bootstrap.js") ]
    ),
  ]
)
