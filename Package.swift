// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "co-hn",
    platforms: [
        .macOS(.v13), .iOS(.v17)
    ],
    products: [
        .library(
            name: "OmniFocusTaskIntentKit",
            targets: ["OmniFocusTaskIntentKit"]
        ),
        .executable(
            name: "TaskIntentCLI",
            targets: ["TaskIntentCLI"]
        )
    ],
    targets: [
        .target(
            name: "OmniFocusTaskIntentKit"
        ),
        .executableTarget(
            name: "TaskIntentCLI",
            dependencies: ["OmniFocusTaskIntentKit"]
        ),
        .testTarget(
            name: "OmniFocusTaskIntentKitTests",
            dependencies: ["OmniFocusTaskIntentKit"]
        )
    ]
)
