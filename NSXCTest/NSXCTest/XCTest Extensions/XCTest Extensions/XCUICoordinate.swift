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
        NSLogger.info()
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
        NSLogger.info()
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
        NSLogger.info()
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
        NSLogger.info()
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
        NSLogger.info()
        let coordinate = self.coordinate(withNormalizedOffset: CGVector())
        let endCoordinate = self.coordinate(withNormalizedOffset: CGVector())

        let triggerCoordinate = coordinate.withOffset(CGVector(dx: fromX, dy: fromY))
        let endTriggerCoordinate = endCoordinate.withOffset(CGVector(dx: toX, dy: toY))
        triggerCoordinate.press(forDuration: duration, thenDragTo: endTriggerCoordinate)
    }
}
