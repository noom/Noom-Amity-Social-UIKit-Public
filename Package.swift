// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AmityUIKit",
    platforms: [
            .iOS(.v14)
        ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AmityUIKit",
            targets: ["AmityUIKit"]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/AmityCo/Amity-Social-Cloud-SDK-iOS-SwiftPM.git", .exactItem(Version(5, 32, 0))),
        .package(url: "https://github.com/SnapKit/SnapKit.git", exact: "5.0.1"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", exact: "0.52.0"),
    ],
    targets: [
        .target(
            name: "AmityUIKit",
            dependencies: [
                .product(name: "AmitySDK", package: "Amity-Social-Cloud-SDK-iOS-SwiftPM"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ],
            path: "UpstraUIKit/UpstraUIKit",
            resources: [
                .process("Localization/AmityLocalizable.strings")
            ]
        )
    ]
)
