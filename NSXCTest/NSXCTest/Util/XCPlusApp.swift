import Foundation

/// :nodoc:
public enum SystemApp: String {
    case springBoard = "com.apple.springboard"
    case settings = "com.apple.Preferences"

    public var bundleId: String {
        return self.rawValue
    }
}

/// Application Manager
public class XCPlusApp {

    /// Launch Application with mentioned bundle id in build config
    public static func launchApplication() {
        NSLogger.info()
        XCPlusApp.aut.launch()
    }
    
    /// Activate Target Application
    public static func activateApplication() {
        NSLogger.info()
        XCPlusApp.aut.activate()
    }

    /// Get `XCUIApplication` object of active application
    public static func activeApplication() -> XCUIApplication {
        NSLogger.info()
        return XCTestWDApplication.activeApplication()
    }

    /// Launch Settings Application
    public static func launchSettingsApplication() {
        NSLogger.info()
        launchApplication(bundleIdentifier: SystemApp.settings.bundleId)
    }

    /// Launch application with valid bundle identifier
    ///
    /// **Example:**
    ///
    /// ```swift
    /// XCPlusApp.launchApplication(bundleIdentifier: "com.apple.springboard")
    /// ```
    ///
    /// - Parameters:
    ///   - bundleIdentifier: Bundle Identifier
    ///

    public static func launchApplication(bundleIdentifier: String, launchArguments: [String] = [], launchEnvironment: [String: String] = [:]) {
        NSLogger.info(message: "\(bundleIdentifier)")
        let app = XCUIApplication(bundleIdentifier: bundleIdentifier)
        app.launchArguments = launchArguments
        app.launchEnvironment = launchEnvironment
        app.launch()
        sleep(2)
    }

    private static var aut: XCUIApplication {
        NSLogger.info()
        if let autBundleId = ProcessInfo.processInfo.getValue(forKey: BuildConfig.autBundleId.rawValue) {
            return XCUIApplication(bundleIdentifier: autBundleId)

        } else {
            return XCUIApplication()
        }
    }
}

public var app: XCUIApplication {
    return XCPlusApp.activeApplication()
}
