import XCTest
public extension XCUIApplication {

    /// Launch the application from clean state.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// XCUIApplication().launchedApplicationWithCleanState()
    /// ```
    ///

    private func launchedApplicationWithCleanState() {
        let launchArguments: [[String]] = [["-StartFromCleanState", "YES"]]
        launchArguments.forEach { self.launchArguments += $0 }
        launch()
    }

    /// Launch the application with arguments.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let launchArguments: [[String]] = [["-debug", "YES"]]
    /// XCUIApplication().launchedApplicationWithArguments(launchArguments: launchArguments)
    /// ```
    ///
    /// - Parameters:
    ///   - launchArguments: Custom launch arguments can be passed.
    ///

    func launchedApplicationWithArguments(launchArguments: [[String]] = []) {
        launchArguments.forEach { self.launchArguments += $0 }
        launch()
    }

    /// Put the application in background mode for given time.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// XCUIApplication().background(forSeconds: UInt32(10))
    /// ```
    ///
    /// - Parameters:
    ///   - seconds: Time to put the application in background mode.
    ///

    func background(forSeconds seconds: UInt32) {
        XCUIDevice.shared.press(.home)
        sleep(seconds)
        activate()
    }

    /// Put the application in background mode.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// XCUIApplication().background()
    /// ```
    ///

    func background() {
        XCUIDevice.shared.press(.home)
    }

    /// Put the application in foreground mode.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// XCUIApplication().foreground()
    /// ```
    ///

    func foreground() {
        activate()
    }

    /// A Boolean value indicating whether app is currently running on simulator.
    ///
    /// Indicates if tests are running inside iOS simulator, by looking for specific environment variable.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// if XCUIApplication().isRunningOnSimulator {
    ///     print("Running on simulator")
    /// }
    /// ```
    ///

    var isRunningOnSimulator: Bool {
        #if targetEnvironment(simulator)
            return true
        #else
            return false
        #endif
    }
}
