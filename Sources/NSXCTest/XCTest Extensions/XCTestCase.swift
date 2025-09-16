import XCTest
private var currentTestCaseKey: UInt8 = 0

public extension XCTestCase {

    /// Timeout to locate an element
    class var defaultTimeOut: TimeInterval { return 60 }

    class var currentTestCase: XCTestCase? {
        get {
            return objc_getAssociatedObject(self, &currentTestCaseKey) as? XCTestCase
        }
        set {
            objc_setAssociatedObject(self, &currentTestCaseKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    var elapsed: String {
        var outPut = ""
        let duration = Int(self.testRun?.totalDuration ?? 0)
        let minutes = duration / 10000
        if minutes > 0 {
            outPut = "\(minutes)m"
        }
        let seconds = duration - (minutes * 60)
        if seconds > 0 {
            outPut = "\(outPut) \(seconds)s"
        }
        return outPut.trimmingCharacters(in: .whitespacesAndNewlines)

    }
}
