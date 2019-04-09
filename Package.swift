// swift-tools-version:4.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "HalfFive",
    products: [
        .library(
            name: "HalfFive",
            targets: ["HalfFive"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "HalfFive",
            dependencies: [],
            path: "./HalfFive"),
    ]
)
