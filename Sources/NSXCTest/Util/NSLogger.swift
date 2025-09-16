import Foundation
import XCTest

struct ISXCTestDebugInfo {
    static let DebugLogPrefix = "[NSXCTest]"
}

/// Log Type
enum LogLevel: String {
    case info
    case debug
    case error
    case warn
}

/// NSLogger is for reporting
public class NSLogger {

    /// Log type info
    public class func info(function: String = #function, file: String = #file, line: Int = #line, message: String = "") {
    }

    /// Log type debug
    public class func debug(function: String = #function, file: String = #file, line: Int = #line, message: String = "") {
    }

    /// Log type error
    public class func error(function: String = #function, file: String = #file, line: Int = #line, message: String = "") {
    }

    /// Log type warn
    public class func warn(function: String = #function, file: String = #file, line: Int = #line, message: String = "") {
    }
    
    /// Attach Text
    public class func attach(message: String = "", name: String = "Attachment", lifetime: XCTAttachment.Lifetime = .deleteOnSuccess) {
        let attachment = XCTAttachment(string: message)
        attachment.name = name.replacingOccurrences(of: ".", with: "-")
        attachment.lifetime = lifetime
        XCTestCase.currentTestCase?.add(attachment)
    }
    
    /// Attach Plist
    public class func attach(plist: Any, name: String = "Attachment", lifetime: XCTAttachment.Lifetime = .deleteOnSuccess) {
        let attachment = XCTAttachment(plistObject: plist)
        attachment.name = name.replacingOccurrences(of: ".", with: "-")
        attachment.lifetime = lifetime
        XCTestCase.currentTestCase?.add(attachment)
    }
    
    /// Attach Json
    public class func attach(json: Any, name: String = "Attachment", lifetime: XCTAttachment.Lifetime = .deleteOnSuccess) {
        var attachment = XCTAttachment(string: "No Data")
        
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
            attachment = XCTAttachment(data: jsonData, uniformTypeIdentifier: "public.json")
        } catch {
            attachment = XCTAttachment(string: json as? String ?? "")
        }
        attachment.name = name.replacingOccurrences(of: ".", with: "-")
        attachment.lifetime = lifetime
        XCTestCase.currentTestCase?.add(attachment)
    }
    
    /// Attach Screenshot
    public class func attachScreenshot(quality: XCTAttachment.ImageQuality = .original) {
        let screenshot = XCUIScreen.main.screenshot()
        let attachment = XCTAttachment(screenshot: screenshot, quality: quality)
        attachment.lifetime = .keepAlways
        XCTestCase.currentTestCase?.add(attachment)

    }
    
    private class func prefix(function: String, file: String, line: Int, level: LogLevel) -> String {
        var className = URL(fileURLWithPath: file).lastPathComponent
        if className == "" {
            className = file
        }

        let separator: String = " || "
        return Date().toString()
            + separator + "\(level.rawValue.uppercased())"
            + separator + "\(ISXCTestDebugInfo.DebugLogPrefix)"
            + separator + "\(className)"
            + separator + function
            + separator + "\(line)"
            + separator
    }
}
