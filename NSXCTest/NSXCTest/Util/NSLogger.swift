import Foundation
import CocoaLumberjackSwift

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

    /// :nodoc:
    public static let shared = NSLogger()

    private var currentContext: Int
    private var allDDFileLogger: [Int: DDFileLogger]

    init() {
        self.currentContext = Int(arc4random())
        self.allDDFileLogger = [Int: DDFileLogger]()
    }

    /// Create new logger file
    ///
    /// **Example:**
    ///
    /// ```swift
    /// NSLogger.shared.addNewLogger(withLogDirectory: "directory", fileName: "common.log")
    /// ```
    ///
    /// - Parameters:
    ///   - withLogDirectory: Bundle Identifier
    ///   - fileName: File Name
    ///

    @discardableResult
    public func addNewLogger(withLogDirectory: String = "", fileName: String = "common.log") -> Int {
        self.currentContext = Int(arc4random())

        let paths = NSSearchPathForDirectoriesInDomains(
            FileManager.SearchPathDirectory.documentDirectory,
            FileManager.SearchPathDomainMask.userDomainMask,
            true)

        let logDir = "\(paths[0])/NSXCTestLogs/\(withLogDirectory)"
        print(logDir)
        let ddLogFileManager = DDLogFileManagerDefault(logsDirectory: logDir)
        let fileLogger = DDFileLogger(logFileManager: ddLogFileManager)
        fileLogger.rollingFrequency = TimeInterval(60 * 60 * 24)
        fileLogger.doNotReuseLogFiles = true
        fileLogger.logFileManager.maximumNumberOfLogFiles = 0

        let context = DDContextAllowlistFilterLogFormatter()
        context.add(toAllowlist: self.currentContext)
        fileLogger.logFormatter = context

        DDLog.add(fileLogger)
        DDLogInfo("\(ISXCTestDebugInfo.DebugLogPrefix) Setup log", context: self.currentContext)

        self.allDDFileLogger[self.currentContext] = fileLogger

        return self.currentContext
    }

    /// Switch Logger file
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let logger = NSLogger.shared.addNewLogger(withLogDirectory: "directory", fileName: "common.log")
    /// NSLogger.shared.switchContext(context: logger)
    /// ```
    ///
    /// - Parameters:
    ///   - context: Reference of logger
    ///

    public func switchContext(context: Int) {
        self.currentContext = context
    }

    private func getCurrentContext() -> Int {
        if self.allDDFileLogger[self.currentContext] == nil {
            self.addNewLogger()
        }
        return self.currentContext
    }

    /// Rename current logger file
    ///
    /// **Example:**
    ///
    /// ```swift
    /// NSLogger.shared.renameFile(fileName: "newfile.log")
    /// ```
    ///
    /// - Parameters:
    ///   - fileName: File name
    ///

    public func renameFile(fileName: String) {
        if let fileLogger = self.allDDFileLogger[self.currentContext] {
            fileLogger.currentLogFileInfo?.renameFile(to: fileName)
        } else {
            self.addNewLogger(fileName: fileName)
        }
    }

    /// Get current logger file path
    ///
    /// **Example:**
    ///
    /// ```swift
    /// NSLogger.shared.getLoggerFilePath()
    /// ```
    ///

    public func getLoggerFilePath() -> String {
        if let fileLogger = self.allDDFileLogger[self.currentContext] {
            return fileLogger.currentLogFileInfo?.filePath ?? ""
        }
        return ""
    }

    /// Log type info
    public class func info(function: String = #function, file: String = #file, line: Int = #line, message: String = "") {
        DDLogInfo("\(NSLogger.prefix(function: function, file: file, line: line, level: .info)) \(message)",
            context: NSLogger.shared.getCurrentContext())
    }

    /// Log type debug
    public class func debug(function: String = #function, file: String = #file, line: Int = #line, message: String = "") {
        DDLogDebug("\(NSLogger.prefix(function: function, file: file, line: line, level: .debug)) \(message)",
            context: NSLogger.shared.getCurrentContext())
    }

    /// Log type error
    public class func error(function: String = #function, file: String = #file, line: Int = #line, message: String = "") {
        DDLogError("\(NSLogger.prefix(function: function, file: file, line: line, level: .error)) \(message)",
            context: NSLogger.shared.getCurrentContext())
    }

    /// Log type warn
    public class func warn(function: String = #function, file: String = #file, line: Int = #line, message: String = "") {
        DDLogWarn("\(NSLogger.prefix(function: function, file: file, line: line, level: .warn)) \(message)",
            context: NSLogger.shared.getCurrentContext())
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
