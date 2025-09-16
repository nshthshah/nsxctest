import XCTest
public extension XCUIApplication {

    /// Tap at coordinate.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// XCUIApplication().tap(at: 10.0, and: 10.0)
    /// ```
    ///
    /// - Parameters:
    ///   - xCoordinate: X Coordinate.
    ///   - yCoordinate: Y Coordinate.
    ///

    func tap(at xCoordinate: Double, and yCoordinate: Double) {
        let normalized = self.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let coordinate = normalized.withOffset(CGVector(dx: xCoordinate, dy: yCoordinate))
        coordinate.tap()
    }

    /// Double tap at coordinate.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// XCUIApplication().doubleTap(at: 10.0, and: 10.0)
    /// ```
    ///
    /// - Parameters:
    ///   - xCoordinate: X Coordinate.
    ///   - yCoordinate: Y Coordinate.
    ///

    func doubleTap(at xCoordinate: Double, and yCoordinate: Double) {
        let normalized = self.coordinate(withNormalizedOffset: CGVector(dx: 0, dy: 0))
        let coordinate = normalized.withOffset(CGVector(dx: xCoordinate, dy: yCoordinate))
        coordinate.doubleTap()
    }

    /// Long press at coordinate.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// XCUIApplication().press(at: 10.0, and: 10.0, forDuration: 1)
    /// ```
    ///
    /// - Parameters:
    ///   - xCoordinate: X Coordinate.
    ///   - yCoordinate: Y Coordinate.
    ///   - duration: Duration.
    ///

    func press(at xCoordinate: Double, and yCoordinate: Double, forDuration duration: TimeInterval) {
        let normalized = self.coordinate(withNormalizedOffset: CGVector())
        let coordinate = normalized.withOffset(CGVector(dx: xCoordinate, dy: yCoordinate))
        coordinate.press(forDuration: duration)
    }

    /// Press at coordinate and drag to another coordinate.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let coordinate = XCUIApplication().coordinate(withNormalizedOffset: CGVector(dx: 20.0, dy: 20.0))
    /// XCUIApplication().press(at: 10.0, and: 10.0, forDuration: 1, thenDragTo: coordinate)
    /// ```
    ///
    /// - Parameters:
    ///   - xCoordinate: X Coordinate.
    ///   - yCoordinate: Y Coordinate.
    ///   - duration: Duration.
    ///   - thenDragTo: Coordinate to drag.
    ///

    func press(at xCoordinate: Double,
               and yCoordinate: Double,
               forDuration duration: TimeInterval,
               thenDragTo otherCoordinate: XCUICoordinate) {
        let normalized = self.coordinate(withNormalizedOffset: CGVector())
        let coordinate = normalized.withOffset(CGVector(dx: xCoordinate, dy: yCoordinate))
        coordinate.press(forDuration: duration, thenDragTo: otherCoordinate)
    }

    /// Press at coordinate and drag to another coordinate.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// XCUIApplication().dragForDuration(fromX: 160.0, fromY: Double(app.frame.height), toX: 160.0, toY: 100.0)
    /// ```
    ///
    /// - Parameters:
    ///   - fromX: Trigger X Coordinate.
    ///   - fromY: Trigger Y Coordinate.
    ///   - toX: End Trigger X Coordinate.
    ///   - toY: End Trigger Y Coordinate.
    ///   - duration: Duration.
    ///

    func dragForDuration(fromX: Double, fromY: Double, toX: Double, toY: Double, duration: TimeInterval = 2) {
        let coordinate = self.coordinate(withNormalizedOffset: CGVector())
        let endCoordinate = self.coordinate(withNormalizedOffset: CGVector())

        let triggerCoordinate = coordinate.withOffset(CGVector(dx: fromX, dy: fromY))
        let endTriggerCoordinate = endCoordinate.withOffset(CGVector(dx: toX, dy: toY))
        triggerCoordinate.press(forDuration: duration, thenDragTo: endTriggerCoordinate)
    }

    func swipe(dxFrom: Double, dyFrom: Double, dxTo: Double, dyTo: Double) {
        let startPoint = self.coordinate(withNormalizedOffset:
                                            CGVector(dx: dxFrom, dy: dyFrom))
        let endPoint = self.coordinate(withNormalizedOffset:
                                        CGVector(dx: dxTo, dy: dyTo))
        startPoint.press(forDuration: 0.1, thenDragTo: endPoint)
    }

    /// Simulates a swipe gesture from the bottom to the top of the screen.
    ///
    /// - Parameters:
    ///   - offsetFromTop: The offset in points from the top of the screen. Positive values move the swipe start point downwards from the top.
    ///   - offsetFromBottom: The offset in points from the bottom of the screen. Positive values move the swipe start point upwards from the bottom.
    ///
    func swipeTo(scrollDirection direction: ScrollDirection = .up,
                 offsetFromTop: Double = 0.2,
                 offsetFromBottom: Double = 0.20,
                 withVelocity: Int = 150,
                 holdForDuration: Double = 0.5) {
        let screenSize = windows.element(boundBy: 0).frame.size

        let startPoint = CGPoint(x: 10, y: screenSize.height - offsetFromBottom * screenSize.height)
        let endPoint = CGPoint(x: 10, y: offsetFromTop * screenSize.height)

        let start = coordinate(withNormalizedOffset: CGVector(dx: startPoint.x / screenSize.width, dy: startPoint.y / screenSize.height))
        let end = coordinate(withNormalizedOffset: CGVector(dx: endPoint.x / screenSize.width, dy: endPoint.y / screenSize.height))

        let velocity = XCUIGestureVelocity(integerLiteral: withVelocity)
        
        switch direction {
        case .up:
            start.press(forDuration: 0.001, thenDragTo: end, withVelocity: velocity, thenHoldForDuration: holdForDuration)
        case .down:
            end.press(forDuration: 0.001, thenDragTo: start, withVelocity: velocity, thenHoldForDuration: holdForDuration)
        default:
            NSLogger.attach(message: "Not Yet Implemented: \(direction.rawValue)")
        }
        
        sleep(UInt32(0.5))
    }
}
