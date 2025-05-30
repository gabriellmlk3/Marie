// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MarieLib",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "MarieLib",
            targets: ["Marie"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Marie",
            dependencies: [],
            path: "Sources/Marie",
            resources: [.process("Assets.xcassets")]),
    ]
)
