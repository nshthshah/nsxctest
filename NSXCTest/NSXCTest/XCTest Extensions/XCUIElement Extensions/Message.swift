import Foundation

internal class Message {

    class func message(forOperation opr: String, outcome: Bool, locator: String) -> String {
        let outcomeString: String = outcome ? "pass" : "fail"
        let key = "element.\(opr).\(outcomeString)"
        guard let value = messages[key] else {
            AssertFail(message: String(format: NOT_YET_IMPLEMENTED, key))
            return ""
        }
        let message = String(format: value, locator, locator)
        NSLogger.attach(message: message)
        return message
    }

    class func message(forOperation opr: String, outcome: Bool, locator: String, expected: String, actual: String) -> String {
        let outcomeString: String = outcome ? "pass" : "fail"
        let key = "element.\(opr).\(outcomeString)"
        guard let value = messages[key] else {
            AssertFail(message: String(format: NOT_YET_IMPLEMENTED, key))
            return ""
        }
        let message = String(format: value, locator, expected, locator, actual)
        NSLogger.attach(message: message)
        return message
    }
}
