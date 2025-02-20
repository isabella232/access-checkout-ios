// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package

import PackageDescription

let package = Package(
    name: "AccessCheckoutSDK",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(name: "AccessCheckoutSDK", targets: ["AccessCheckoutSDK"])
    ],
    targets: [
        .target(
            name: "AccessCheckoutSDK", dependencies: [], path: "AccessCheckoutSDK/AccessCheckoutSDK"
        )
    ]
)
