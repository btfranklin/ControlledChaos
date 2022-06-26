// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ControlledChaos",
    platforms: [
        .macOS(.v11), .iOS(.v14), .tvOS(.v14), .watchOS(.v7)
    ],
    products: [
        .library(
            name: "ControlledChaos",
            targets: ["ControlledChaos"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ControlledChaos",
            dependencies: []),
        .testTarget(
            name: "ControlledChaosTests",
            dependencies: ["ControlledChaos"]),
    ]
)
