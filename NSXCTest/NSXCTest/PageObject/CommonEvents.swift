import Foundation

/// KeyboardEvents Protocol
public protocol KeyboardEvents { }

public extension KeyboardEvents {

    /// This will hide the keyboard if it is open.
    /// Must have to conform `KeyboardEvents` protocol to use methods.
    /// First prefer `dismissKeyboard` method, if it will not work then use this method.
    ///

    func hideKeyboard() {
        let keyboard = XCPlusApp.activeApplication().keyboards.element
        if keyboard.isVisible {
            if UIDevice.current.isIpad {
                if keyboard.buttons[KeyboardLocator.dismiss].isVisible {
                    keyboard.buttons[KeyboardLocator.dismiss].tapWithWait()
                } else if keyboard.buttons[KeyboardLocator.hideKeyboard].isVisible {
                    keyboard.buttons[KeyboardLocator.hideKeyboard].tapWithWait()
                }
            } else if UIDevice.current.isIphone, keyboard.buttons[KeyboardLocator.return].isVisible {
                keyboard.buttons[KeyboardLocator.return].tapWithWait()
            }
        } else {
            NSLogger.attach(message: "Keyboard is not visible", name: "Hide Keyboard")
        }
    }

    /// This will dismiss keyboard if it is open
    /// Must have to conform `KeyboardEvents` protocol to use methods.
    ///

    func dismissKeyboard() {
        XCTestDaemonsProxy.testRunnerProxy()._XCT_send("\n", maximumFrequency: 60) { error in
            if error != nil {
                NSLogger.attach(message: "Error occured in sending key: \(error.debugDescription)", name: "Dismiss Keyboard")
            }
        }
    }

    func switchKeyboard(toLanguage language: String) {
        NSLogger.attach(message: language)
        let app = XCPlusApp.activeApplication()

        let keyboard = app.keyboards.element
        if keyboard.exists {
            if app.buttons[KeyboardLocator.emoji].isVisible {
                app.buttons[KeyboardLocator.emoji].press(forDuration: 2)
                KeyboardLocator.keyboardLanguage.element(arguments: language).tapWithWait()
            }
        } else {
            NSLogger.attach(message: "Keyboard is not visible", name: "Switch Keyboard")
        }

    }
}

/// Conform `CommonEvents` protocol to access all common events.
///
/// **Example:**
///
/// ```swift
/// import NSXCTest
///
/// class AccountScreen: BaseScreen, CommonEvents {
///
///     override func waitForScreenToLoad() {
///         hideKeyboard()
///     }
/// }
/// ```

public protocol CommonEvents: KeyboardEvents { }

extension CommonEvents {

    var app: XCUIApplication {
        return XCPlusApp.activeApplication()
    }

    func idle(forSeconds seconds: Int) {
        CFRunLoopRunInMode(CFRunLoopMode.defaultMode, TimeInterval(seconds), true)
    }
}
