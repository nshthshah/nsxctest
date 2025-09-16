// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NSXCTest",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "NSXCTest",
            targets: ["NSXCTest"])
    ],
    dependencies: [
        .package(url: "https://github.com/httpswift/swifter.git", .upToNextMajor(from: "1.5.0")),
        .package(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", .upToNextMajor(from: "4.2.0")),
        .package(url: "https://github.com/cezheng/Fuzi.git", .upToNextMajor(from: "3.1.0")),
        .package(url: "https://github.com/tadija/AEXML.git", .upToNextMajor(from: "4.6.0")),
        .package(url: "https://github.com/CocoaLumberjack/CocoaLumberjack.git", .upToNextMajor(from: "3.4.0"))
    ],
    targets: [
        .target(
            name: "NSXCTestObjC",
            dependencies: [],
            path: "Sources/NSXCTestObjC",
            sources: [
                "FBConfiguration.m",
                "NSPredicate+NSXCTest.m",
                "NSXCTestImplementationFailureHoldingProxy.m",
                "UIDevice+SerialNumber.m",
                "XCRuntimeUtils.m",
                "XCTestDaemonsProxy.m",
                "XCTestPrivateSymbols.m",
                "XCTestWDApplication.m",
                "XCTestXCAXClientProxy.m",
                "XCTestXCodeCompatibility.m",
                "include/_XCTestCaseImplementation.h",
                "include/CDStructures.h",
                "include/FBConfiguration.h",
                "include/libxml2-fuzi.h",
                "include/NSPredicate+NSXCTest.h",
                "include/NSXCTestImplementationFailureHoldingProxy.h",
                "include/TIPreferencesController.h",
                "include/UIDevice+SerialNumber.h",
                "include/UIKeyboardImpl.h",
                "include/XCAXClient_iOS.h",
                "include/XCDebugLogDelegate-Protocol.h",
                "include/XCElementSnapshot.h",
                "include/XCRuntimeUtils.h",
                "include/XCTElementSetTransformer-Protocol.h",
                "include/XCTestCase.h",
                "include/XCTestDaemonsProxy.h",
                "include/XCTestDriver.h",
                "include/XCTestDriverInterface-Protocol.h",
                "include/XCTestManager_IDEInterface-Protocol.h",
                "include/XCTestManager_ManagerInterface-Protocol.h",
                "include/XCTestManager_TestsInterface-Protocol.h",
                "include/XCTestPrivateSymbols.h",
                "include/XCTestWDApplication.h",
                "include/XCTestXCAXClientProxy.h",
                "include/XCTestXCodeCompatibility.h",
                "include/XCTRunnerDaemonSession.h",
                "include/XCUIApplication.h",
                "include/XCUICoordinate.h",
                "include/XCUIDevice.h",
                "include/XCUIElement.h",
                "include/XCUIElementQuery.h",
                "include/NSPasteboard.h",
                "NSPasteboard.m"
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("include")
            ],
            linkerSettings: [
                .linkedLibrary("xml2"),
                .unsafeFlags(["-Wl,-U","_OBJC_CLASS_$_XCElementSnapshot"])
            ]
        ),
        .target(
            name: "NSXCTest",
            dependencies: [
                "NSXCTestObjC",
                .product(name: "Swifter", package: "swifter"),
                .product(name: "SwiftyJSON", package: "SwiftyJSON"),
                .product(name: "Fuzi", package: "Fuzi"),
                .product(name: "AEXML", package: "AEXML"),
                .product(name: "CocoaLumberjack", package: "CocoaLumberjack"),
                .product(name: "CocoaLumberjackSwift", package: "CocoaLumberjack")
            ],
            path: "Sources/NSXCTest",
            resources: [
                .process("SystemAlert/PushNotification")
            ]
        )
    ]
)
