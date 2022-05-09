// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AccessCheckoutSDK",
    platforms: [
        // Add support for all platforms starting from a specific version.
        .macOS(.v11),
        .iOS(.v11),
        // .watchOS(.v5),
        // .tvOS(.v11)
    ],
    products: [
        .library(name: "AccessCheckoutSDK", targets: ["AccessCheckoutSDK"], path: "AccessCheckoutSDK")
    ],
    targets: [
        .target(name: "AccessCheckoutSDK", dependencies: [])
    ]
)
