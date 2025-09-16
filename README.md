## NSXCTest

Powerful helpers and extensions for building robust iOS UI tests with XCTest.

This framework combines Swift utilities with a thin Objective‑C bridge to unlock advanced capabilities of XCTest, such as rich element querying, reliable waits, system alert handling, and convenient Page Object patterns.

### What is this framework?

- Extensions on `XCUIElement`, `XCUIElementQuery`, and `XCTestCase` for actions, assertions, waits, properties, and verifications
- XPath and class‑chain querying of accessibility snapshots
- System alert handling (e.g., Push Notification permissions)
- Page Object utilities and common events
- Structured logging and performance utilities
- Objective‑C shims that interoperate with XCTest internals where needed

### Add as a dependency (Swift Package Manager)

Add the package to your XCTest project. You can use Xcode’s UI or edit `Package.swift` directly.

Repo: [github.com/nshthshah/nsxctest](https://github.com/nshthshah/nsxctest.git)

Using Xcode:
- Xcode → File → Add Package Dependencies…
- Enter your repository URL and add the library product `NSXCTest` to your UI test target

Using `Package.swift`:

```swift
// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "YourTests",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "YourTests", targets: ["YourTests"]) // example
    ],
    dependencies: [
        .package(url: "https://github.com/nshthshah/nsxctest.git", branch: "main")
    ],
    targets: [
        .testTarget(
            name: "YourUITests",
            dependencies: [
                .product(name: "NSXCTest", package: "nsxctest")
            ]
        )
    ]
)
```

Notes:
- Minimum iOS version is 13 (CryptoKit usage).
- Build and run under an iOS Simulator/device test environment (XCTest must be present).

### Example

```swift
import XCTest
import NSXCTest

final class LoginUITests: XCTestCase {
    func testLogin() {
        let app = XCUIApplication()
        app.launch()

        // Use extended element helpers
        app.textFields["Email"].tap()
        app.typeText("user@example.com")

        app.secureTextFields["Password"].tap()
        app.typeText("correct-horse-battery-staple")

        app.buttons["Sign In"].tap()

        // Example: wait/assert using provided utilities
        XCTAssertTrue(app.staticTexts["Welcome"].waitForExistence(timeout: 10))
    }
}
```

### Features

- Extended XCTest APIs (actions, assertions, waits)
- XPath/class‑chain element querying
- System alert helpers (e.g., Push Notifications)
- Page Object scaffolding and common events
- Logging and simple performance monitoring

**Nishith Shah**

[![LinkedIn](https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white)](https://www.linkedin.com/in/nshthshah/)
[![GitHub](https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white)](https://github.com/nshthshah)

## 📄 License

MIT License


