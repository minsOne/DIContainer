// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DIContainer",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "DIContainer",
                 targets: ["DIContainer"]),
        .library(name: "DIContainer-Dynamic",
                 type: .dynamic,
                 targets: ["DIContainer"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "./MockData"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DIContainer",
            dependencies: []
        ),
        .testTarget(
            name: "DIContainerTests",
            dependencies: ["DIContainer", "MockData"]
        ),
    ]
)
