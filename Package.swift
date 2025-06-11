// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MarieLib",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "MarieLib",
            targets: ["Marie"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager", from: "8.0.0"),
        .package(url: "https://github.com/krzyzanowskim/CoreTextSwift.git", from: "0.0.2")
    ],
    targets: [
        .target(
            name: "Marie",
            dependencies: [
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
                .product(name: "CoreTextSwift", package: "CoreTextSwift")
            ],
            path: "Sources/Marie",
            resources: [.process("Assets.xcassets")]
        ),
    ]
)
