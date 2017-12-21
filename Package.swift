// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "WordCase",
    products: [
        .library(
            name: "WordCase",
            targets: ["WordCase"]),
    ],
    targets: [
        .target(
            name: "WordCase",
            dependencies: []),
        .testTarget(
            name: "WordCaseTests",
            dependencies: ["WordCase"]),
    ]
)
