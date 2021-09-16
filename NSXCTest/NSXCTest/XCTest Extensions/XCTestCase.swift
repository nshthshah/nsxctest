public extension XCTestCase {

    /// Timeout to locate an element
    class var defaultTimeOut: TimeInterval { return 60 }

    private static var _currentTestCase: XCTestCase?

    /// Object of `XCTestCase` which is executing
    class var currentTestCase: XCTestCase? {
        get { return _currentTestCase }
        set(currentTestCase) { _currentTestCase = currentTestCase }
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
