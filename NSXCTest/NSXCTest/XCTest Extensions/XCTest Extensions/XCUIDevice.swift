import Foundation

/// :nodoc:
extension Notification.Name {
    static let fingerTouchMatch = Notification.Name("com.apple.BiometricKit_Sim.fingerTouch.match")
    static let fingerTouchNoMatch = Notification.Name("com.apple.BiometricKit_Sim.fingerTouch.nomatch")

    static let faceIdMatch = Notification.Name("com.apple.BiometricKit_Sim.pearl.match")
    static let faceIdNoMatch = Notification.Name("com.apple.BiometricKit_Sim.pearl.nomatch")
}

public extension XCUIDevice {

    /// :nodoc:
    func adjustDimensionsForApplication(_ actualSize: CGSize, _ orientation: UIDeviceOrientation) -> CGSize {
        if orientation == UIDeviceOrientation.landscapeLeft || orientation == UIDeviceOrientation.landscapeRight {
            if actualSize.height > actualSize.width {
                return CGSize(width: actualSize.height, height: actualSize.width)
            }
        }
        return actualSize
    }

    /// Press Home button
    func home() {
        self.press(.home)
        sleep(3)
    }

    /// Airplane Mode
    func setAirplaneMode(to expectedStatus: Bool) {
        XCPlusApp.launchApplication(bundleIdentifier: SystemApp.settings.bundleId)
        let app = XCPlusApp.activeApplication()
        if let currentStatus = app.switches["Airplane Mode"].value as? Bool {
            if currentStatus == expectedStatus {
                return
            }
        } else if let currentStatus = app.switches["Airplane Mode"].value as? String {
            if currentStatus.boolValue == expectedStatus {
                return
            }
        }
        app.tables.cells["Airplane Mode"].switches.element.tap()
    }

    /// Simulate Finger Touch
    #if targetEnvironment(simulator)
    func fingerTouchShouldMatch(shouldMatch: Bool) {
        if shouldMatch {
            NotificationCenter.default.post(name: .fingerTouchMatch, object: nil)
        } else {
            NotificationCenter.default.post(name: .fingerTouchNoMatch, object: nil)
        }
    }

    /// Simulate Face Id
    func faceIdShouldMatch(shouldMatch: Bool) {
        if shouldMatch {
            NotificationCenter.default.post(name: .faceIdMatch, object: nil)
        } else {
            NotificationCenter.default.post(name: .faceIdNoMatch, object: nil)
        }
    }

    #endif

    /// Get Cellular Strength
    func getCellularStrength() -> String {
         let app = XCUIApplication(bundleIdentifier: SystemApp.springBoard.bundleId)
         let element = app.otherElements.element(withLabelEqualTo: "Cellular")
         var message = "No Status for Cellular"
         if element.exists {
             message = element.value as? String ?? "No Status for Cellular"
         }
         NSLogger.attach(message: message)
         return message
     }

    /// Get WiFi Strength
    func getWiFiStrength() -> String {
         let app = XCUIApplication(bundleIdentifier: SystemApp.springBoard.bundleId)
         let element = app.otherElements.element(withIdLike: "*Wi-Fi bars*")
         var message = "No Status Wi-Fi bars"
         if element.exists {
             message = element.value as? String ?? "No Status Wi-Fi bars"
         }
         NSLogger.attach(message: message)
         return message
     }
}
