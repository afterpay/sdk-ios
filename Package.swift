// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "afterpay-ios",
    products: [
        .library(name: "Afterpay", targets: ["afterpay-ios"]),
    ],
    dependencies: [],
    targets: [
        .target(name: "afterpay-ios", dependencies: []),
        .testTarget(name: "afterpay-iosTests", dependencies: ["afterpay-ios"]),
    ]
)
