import Foundation
import NSXCTestObjC
import XCTest

/// :nodoc:
public enum SystemApp: String {
    case springBoard = "com.apple.springboard"
    case settings = "com.apple.Preferences"
    case safari = "com.apple.mobilesafari"

    public var bundleId: String {
        return self.rawValue
    }
}

/// Application Manager
public class XCPlusApp {

    /// Launch Application with mentioned bundle id in build config
    public static func launchApplication() {
        XCPlusApp.aut.launch()
    }

    /// Launch application with arguments and environment
    ///
    /// **Example:**
    ///
    /// ```swift
    /// XCPlusApp.launchApplication(launchArguments: ["args"], launchEnvironment: [{"key": "value"}])
    /// ```
    ///
    /// - Parameters:
    ///   - launchArguments: Launch Arguments
    ///   - launchEnvironment: Launch Environment
    ///

    public static func launchApplication(launchArguments: [String] = [], launchEnvironment: [String: String] = [:]) {
        let app = XCPlusApp.aut
        app.launchArguments = launchArguments
        app.launchEnvironment = launchEnvironment
        app.launch()
        for _ in 0..<3 {
            if app.wait(for: .runningForeground, timeout: 60) {
                break
            } else {
                XCTContext.runActivity(named: "Terminate and relaunch app") { _ in
                    app.terminate()
                    let _ = app.wait(for: .notRunning, timeout: 10)
                    app.launch()
                }
            }
        }
    }

    /// Activate Target Application
    public static func activateApplication() {
        XCPlusApp.aut.activate()
    }

    /// Get `XCUIApplication` object of active application
    public static func activeApplication() -> XCUIApplication {
        return XCTestWDApplication.activeApplication()
    }

    /// Get `XCUIApplication` list object of all active applications
    public static func activeApplications() -> [XCUIApplication] {
        return XCTestWDApplication.activeApplications()
    }

    /// Launch Settings Application

    @discardableResult
    public static func launchSettings() -> XCUIApplication {
        return launchApplication(bundleIdentifier: SystemApp.settings.bundleId)
    }

    /// Launch Safari Application

    @discardableResult
    public static func launchSafari() -> XCUIApplication {
        return launchApplication(bundleIdentifier: SystemApp.safari.bundleId)
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

    @discardableResult
    public static func launchApplication(bundleIdentifier: String, launchArguments: [String] = [], launchEnvironment: [String: String] = [:]) -> XCUIApplication {
        let app = XCUIApplication(bundleIdentifier: bundleIdentifier)
        app.launchArguments = launchArguments
        app.launchEnvironment = launchEnvironment
        app.launch()

        for _ in 0..<3 {
            if app.wait(for: .runningForeground, timeout: 60) {
                break
            } else {
                XCTContext.runActivity(named: "Terminate and relaunch app") { _ in
                    app.terminate()
                    let _ = app.wait(for: .notRunning, timeout: 10)
                    app.launch()
                }
            }
        }

        return app
    }

    public static func waitForAppRunningForeground(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) {
        var activeApplications: [XCUIApplication] = []
        while activeApplications.count == 0 {
            activeApplications = XCPlusApp.activeApplications()
            sleep(1)
        }
    }

    public static var aut: XCUIApplication {
        if let autBundleId = ProcessInfo.processInfo.getValue(forKey: BuildConfig.autBundleId.rawValue) {
            return XCUIApplication(bundleIdentifier: autBundleId)

        } else {
            return XCUIApplication()
        }
    }

    @discardableResult
    public static func waitForSpringboardToBeActive(timeout: TimeInterval = 30) -> Bool {
        let startTime = Date()
        var isSpringboardActive = false

        while Date().timeIntervalSince(startTime) < timeout {
            let activeApplications = XCPlusApp.activeApplications()
            for activeApplication in activeApplications {
                if activeApplication.bundleID == SystemApp.springBoard.rawValue {
                    isSpringboardActive = true
                    break
                }
            }

            if isSpringboardActive {
                return true
            }
            Thread.sleep(forTimeInterval: 0.1)
        }
        return false
    }
}

public var app: XCUIApplication {
    return XCPlusApp.activeApplication()
}
