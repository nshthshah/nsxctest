import Foundation
import XCTest
import UIKit

/// :nodoc:
public enum SwipeDirection: String {
    /// Swipe up.
    case up
    /// Swipe down.
    case down
    /// Swipe to the left.
    case left
    /// Swipe to the right.
    case right

    var lowercased: String {
        return self.rawValue.lowercased()
    }
}

public extension XCUIElement {
    
    /// Scroll to the element till it is vibile.
    /// This will scroll by using default scroll method.
    /// **Example:**
    ///
    /// ```swift
    /// let label = app.userNameLabel.element
    ///
    /// let label = CL.userNameLabel.element
    /// label.scrollTo()
    /// ```
    ///
    /// - Parameters:
    ///   - direction: Swipe direction (deault: Direction is up).
    ///   - maxNumberOfSwipes: Maximum number of swipes (by default 5).
    ///
    func scrollTo(scrollDirection direction: ScrollDirection = .up, maxNumberOfSwipes: Int = XCUIElement.defaultSwipesCount) {
        var maxCount = maxNumberOfSwipes
        let app = XCPlusApp.activeApplication()
        while maxCount > 0 {
            if !(self.exists && self.isHittable) {
                switch direction {
                case .up:
                    app.swipeUp()
                case .down:
                    app.swipeDown()
                case .left:
                    app.swipeLeft()
                case .right:
                    app.swipeRight()
                }
                maxCount -= 1
                continue
            }
            return
        }
    }

    /// Scroll to the element till it is vibile.
    /// **Example:**
    ///
    /// ```swift
    /// let label = app.userNameLabel.element
    ///
    /// let label = CL.userNameLabel.element
    /// label.scrollToVisible()
    /// ```
    ///
    /// - Parameters:
    ///   - direction: Swipe direction (deault: Direction is up).
    ///   - maxNumberOfSwipes: Maximum number of swipes (by default 5).
    ///   - offsetFromTop: Offset Value from 0 to 1
    ///   - offsetFromBottom: Offset Value from 0 to 1
    ///   - withVelocity: This will decide the speed of scroll (150 means 100.00 pixels per second)
    ///   - waitAfterEachScroll: It will wait after each scroll
    ///

    func scrollToVisible(scrollDirection direction: ScrollDirection = .up, 
                         maxNumberOfSwipes: Int = XCUIElement.defaultSwipesCount,
                         offsetFromTop: Double = 0.2,
                         offsetFromBottom: Double = 0.25,
                         withVelocity: Int = 150,
                         waitAfterEachScroll: Double = 0.2,
                         thenHoldForDuration: Double = 0.001
    ) {
        
        // 150 means 100.00 pixels per second        
        XCTContext.runActivity(named: "Scroll to the element until it is visible") { _ in
            
            var maxCount = maxNumberOfSwipes
            let app = XCPlusApp.activeApplication()
            
            let screenSize = app.windows.element(boundBy: 0).frame.size
            
            let startPoint = CGPoint(x: screenSize.width / 10, y: screenSize.height - offsetFromBottom * screenSize.height)
            let endPoint = CGPoint(x: screenSize.width / 10, y: offsetFromTop * screenSize.height)
            
            let start = app.coordinate(withNormalizedOffset: CGVector(dx: startPoint.x / screenSize.width, dy: startPoint.y / screenSize.height))
            let end = app.coordinate(withNormalizedOffset: CGVector(dx: endPoint.x / screenSize.width, dy: endPoint.y / screenSize.height))
            
            let velocity = XCUIGestureVelocity(integerLiteral: withVelocity)
            NSLogger.attach(message: "Start Scrolling...", name: "Scrolling Event")
            while maxCount > 0 {
                if self.isReallyVisible {
                    NSLogger.attach(message: "Element is Visible", name: "Element is Visible")
                    return
                } else {
                    switch direction {
                    case .up:
                        start.press(forDuration: 0.001, thenDragTo: end, withVelocity: velocity, thenHoldForDuration: thenHoldForDuration)
                    case .down:
                        end.press(forDuration: 0.001, thenDragTo: start, withVelocity: velocity, thenHoldForDuration: thenHoldForDuration)
                    case .left:
                        app.swipeLeft()
                    case .right:
                        app.swipeRight()
                    }
                    maxCount -= 1
                    sleep(UInt32(waitAfterEachScroll))
                }
            }
        }
    }
    
    /// Scrolls the element to make it visible on the screen.
    ///
    /// This method scrolls the element using the default scroll method until it is visible on the screen.
    ///
    /// **Example:**
    /// ```swift
    /// let label = app.userNameLabel.element
    /// label.scrollTo()
    /// ```
    ///
    /// - Parameters:
    ///   - direction: The swipe direction. Defaults to up.
    ///   - maxNumberOfSwipes: The maximum number of swipes. Defaults to 5.
    ///
    /// - Note: If the element is already visible on the screen, this method does nothing.
    ///
    /// - Warning: If the element cannot be scrolled into view after the maximum number of swipes, an assertion failure occurs.
    ///
    /// - Important: Make sure to use this method judiciously, as excessive scrolling may lead to unexpected behavior or performance issues.
    func scrollToCenter() {
        let app = XCPlusApp.activeApplication()
        let appFrame = app.windows.element(boundBy: 0).frame
        let screenSize = appFrame.size
        let offsetFromTop = 0.25
        let offsetFromBottom = 0.25
        
        let yDiff = appFrame.midY - self.frame.midY
        
        var startPoint = CGPointZero
        
        if self.frame.midY < appFrame.midY {
            startPoint = CGPoint(x: screenSize.width / 10, y: offsetFromTop * screenSize.height)
        } else {
            startPoint = CGPoint(x: screenSize.width / 10, y: screenSize.height - offsetFromBottom * screenSize.height)
        }
        let endPoint = CGPoint(x: startPoint.x, y: startPoint.y + yDiff)
        let start = app.coordinate(withNormalizedOffset: CGVector(dx: startPoint.x / screenSize.width, dy: startPoint.y / screenSize.height))
        let end = app.coordinate(withNormalizedOffset: CGVector(dx: endPoint.x / screenSize.width, dy: endPoint.y / screenSize.height))
        
        if abs(start.normalizedOffset.dy - end.normalizedOffset.dy) < 0.02 {
            return
        }

        let velocity = XCUIGestureVelocity(integerLiteral: 150)
        start.press(forDuration: 0.001, thenDragTo: end, withVelocity: velocity, thenHoldForDuration: 0.001)
    }

    /// Default number of swipes.
    class var defaultSwipesCount: Int { return 5 }

    /// Perform swipe gesture on this view by swiping between provided points.
    ///
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let scroll = app.scrollViews.element
    /// scroll.swipe(from: CGVector(dx: 0, dy: 0), to: CGVector(dx: 1, dy: 1))
    /// ```
    ///
    /// - Parameters:
    ///   - startVector: Relative point from which to start swipe.
    ///   - stopVector: Relative point to end swipe.
    ///

    func swipe(from startVector: CGVector, to stopVector: CGVector) {
        let pt1 = coordinate(withNormalizedOffset: startVector)
        let pt2 = coordinate(withNormalizedOffset: stopVector)
        pt1.press(forDuration: 0.05, thenDragTo: pt2)
    }

    /// Swipes scroll view to given direction until condition will be satisfied.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let collectionView = app.collectionViews.element
    /// let element = collectionView.staticTexts["More"]
    /// collectionView.swipe(to: .down, until: element.exists)
    /// ```
    ///
    /// - Parameters:
    ///   - direction: Swipe direction.
    ///   - times: Maximum number of swipes (by default 5).
    ///   - viewsToAvoid: Table of `AvoidableElement` that should be avoid while swiping, by default keyboard and navigation bar are passed.
    ///   - app: Application instance to use when searching for keyboard to avoid.
    ///   - orientation: Device orientation.
    ///   - condition: The condition to satisfy.
    ///

    func swipe(to direction: SwipeDirection,
               times: Int = XCUIElement.defaultSwipesCount,
               avoid viewsToAvoid: [AvoidableElement] = [.keyboard, .navigationBar],
               from app: XCUIApplication = XCPlusApp.activeApplication(),
               orientation: UIDeviceOrientation = XCUIDevice.shared.orientation,
               until condition: @autoclosure () -> Bool) {
        let scrollableArea = self.scrollableArea(avoid: viewsToAvoid, from: app, orientation: orientation)

        // Swipe `times` times in the provided direction.
        for _ in 0..<times {

            // Stop scrolling when condition will be satisfied.
            guard !condition() else {
                break
            }

            // Max swipe offset in both directions.
            let maxOffset = maxSwipeOffset(in: scrollableArea)

            /// Calculates vector for given direction.
            let vector: CGVector
            switch direction {
            case .up: vector = CGVector(dx: 0, dy: -maxOffset.height)
            case .down: vector = CGVector(dx: 0, dy: maxOffset.height)
            case .left: vector = CGVector(dx: -maxOffset.width, dy: 0)
            case .right: vector = CGVector(dx: maxOffset.width, dy: 0)
            }

            // Max possible distance to swipe (normalized).
            let maxNormalizedVector = normalize(vector: vector)

            // Center point.
            let center = centerPoint(in: scrollableArea)

            // Start and stop vectors.
            let (startVector, stopVector) = swipeVectors(from: center, vector: maxNormalizedVector)

            // Swipe.
            swipe(from: startVector, to: stopVector)
        }
    }

    /// Swipes scroll view to given direction until element would exist.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let collectionView = app.collectionViews.element
    /// let element = collectionView.staticTexts["More"]
    /// collectionView.swipe(to: .down, untilExists: element)
    /// ```
    ///
    /// - note:
    ///   This method will not scroll until the view will be visible. To do this call `swipe(to:untilVisible:times:avoid:app:)` after this method.
    ///
    /// - Parameters:
    ///   - direction: Swipe direction.
    ///   - times: Maximum number of swipes (by default 10).
    ///   - viewsToAvoid: Table of `AvoidableElement` that should be avoid while swiping, by default keyboard and navigation bar are passed.
    ///   - app: Application instance to use when searching for keyboard to avoid.
    ///

    func swipe(to direction: SwipeDirection, untilExists element: XCUIElement, times: Int = XCUIElement.defaultSwipesCount, avoid viewsToAvoid: [AvoidableElement] = [.keyboard, .navigationBar], from app: XCUIApplication = XCUIApplication()) {

        swipe(to: direction, times: times, avoid: viewsToAvoid, from: app, until: element.exists)
    }

    /// Swipes scroll view to given direction until element would be visible.
    /// **Example:**
    ///
    /// ```swift
    /// let collectionView = app.collectionViews.element
    /// let element = collectionView.staticTexts["More"]
    /// collectionView.swipe(to: .down, untilVisible: element)
    /// ```
    ///
    /// - note:
    ///   This method will not scroll until the view will be visible. To do this call `swipe(to:avoid:from:)` after this method.
    ///
    /// - Parameters:
    ///   - direction: Swipe direction.
    ///   - element: Element to swipe to.
    ///   - times: Maximum number of swipes (by default 10).
    ///   - viewsToAvoid: Table of `AvoidableElement` that should be avoid while swiping, by default keyboard and navigation bar are passed.
    ///   - app: Application instance to use when searching for keyboard to avoid.
    ///

    func swipe(to direction: SwipeDirection, untilVisible element: XCUIElement, times: Int = XCUIElement.defaultSwipesCount, avoid viewsToAvoid: [AvoidableElement] = [.keyboard, .navigationBar], from app: XCUIApplication = XCUIApplication()) {

        swipe(to: direction, times: times, avoid: viewsToAvoid, from: app, until: element.isVisible)
    }
}

// MARK: - Internal
extension XCUIElement {

    /// Proportional horizontal swipe length.
    ///
    /// - note:
    /// To avoid swipe to back `swipeLengthX` is lower than `swipeLengthY`.
    var swipeLengthX: CGFloat {
        return 0.7
    }

    /// Proportional vertical swipe length.
    var swipeLengthY: CGFloat {
        return 0.7
    }

    /// Calculates scrollable area of the element by removing overlapping elements like keybard or navigation bar.
    ///
    /// - Parameters:
    ///   - viewsToAvoid: Table of `AvoidableElement` that should be avoid while swiping, by default keyboard and navigation bar are passed.
    ///   - app: Application instance to use when searching for keyboard to avoid.
    ///   - orientation: Device orientation.
    /// - Returns: Scrollable area of the element.
    ///

    func scrollableArea(avoid viewsToAvoid: [AvoidableElement] = [.keyboard, .navigationBar], from app: XCUIApplication = XCUIApplication(), orientation: UIDeviceOrientation) -> CGRect {

        let scrollableArea = viewsToAvoid.reduce(frame) {
            $1.overlapReminder(of: $0, in: app, orientation: orientation)
        }
        return scrollableArea
    }

    /// Maximum available swipe offsets (in points) in the scrollable area.
    ///
    /// It takes `swipeLengthX` and `swipeLengthY` to calculate values.
    ///
    /// - Parameter scrollableArea: Scrollable area of the element.
    /// - Returns: Maximum available swipe offsets (in points).
    func maxSwipeOffset(in scrollableArea: CGRect) -> CGSize {
        return CGSize(
            width: scrollableArea.width * swipeLengthX,
            height: scrollableArea.height * swipeLengthY
        )
    }

    /// Normalize vector. From points to normalized values (<0;1>).
    ///
    /// - Parameter vector: Vector to normalize.
    /// - Returns: Normalized vector.
    ///

    func normalize(vector: CGVector) -> CGVector {
        return CGVector(
            dx: vector.dx / frame.width,
            dy: vector.dy / frame.height
        )
    }

    /// Returns center point of the scrollable area in the element in the normalized coordinate space.
    ///
    /// - Parameter scrollableArea: Scrollable area of the element.
    /// - Returns: Center point of the scrollable area in the element in the normalized coordinate space.
    func centerPoint(in scrollableArea: CGRect) -> CGPoint {
        return CGPoint(
            x: (scrollableArea.midX - frame.minX) / frame.width,
            y: (scrollableArea.midY - frame.minY) / frame.height
        )
    }

    /// Calculates swipe vectors from center point and swipe vector.
    ///
    /// Generated vectors can be used by `swipe(from:,to:)`.
    ///
    /// - Parameters:
    ///   - center: Center point of the scrollable area. Use `centerPoint(with:)` to calculate this value.
    ///   - vector: Swipe vector in the normalized coordinate space.
    /// - Returns: Swipes vector to use by `swipe(from:,to:)`.
    ///

    func swipeVectors(from center: CGPoint, vector: CGVector) -> (startVector: CGVector, stopVector: CGVector) {
        // Start vector.
        let startVector = CGVector(
            dx: center.x + vector.dx / 2,
            dy: center.y + vector.dy / 2
        )

        // Stop vector.
        let stopVector = CGVector(
            dx: center.x - vector.dx / 2,
            dy: center.y - vector.dy / 2
        )

        return (startVector, stopVector)
    }

    /// Calculates frame for given orientation.
    ///
    /// - Parameters:
    ///   - orientation: Device 
    ///   - app: Application instance to use when searching for keyboard to avoid.
    /// - Returns: Calculated frame for given orientation.
    ///

    func frame(for orientation: UIDeviceOrientation, in app: XCUIApplication) -> CGRect {

        // Supports only landscape left, landscape right and upside down.
        // For all other unsupported orientations the default frame returned.
        guard orientation == .landscapeLeft
            || orientation == .landscapeRight
            || orientation == .portraitUpsideDown else {
                return frame
        }

        switch orientation {
        case .landscapeLeft:
            return CGRect(x: frame.minY, y: app.frame.width - frame.maxX, width: frame.height, height: frame.width)
        case .landscapeRight:
            return CGRect(x: app.frame.height - frame.maxY, y: frame.minX, width: frame.height, height: frame.width)
        case .portraitUpsideDown:
            return CGRect(x: app.frame.width - frame.maxX, y: app.frame.height - frame.maxY, width: frame.width, height: frame.height)
        default:
            preconditionFailure("Not supported orientation")
        }
    }
}

// MARK: - AvoidableElement
/// Each case relates to element of user interface that can overlap scrollable area.
///
/// - `navigationBar`: equivalent of `UINavigationBar`.
/// - `keyboard`: equivalent of `UIKeyboard`.
/// - `other(XCUIElement, CGRectEdge)`: equivalent of user defined `XCUIElement` with `CGRectEdge` on which it appears.
/// If more than one navigation bar or any other predefined `AvoidableElement` is expected, use `.other` case.
/// Predefined cases assume there is only one element of their type.
///
/// :nodoc:
public enum AvoidableElement {
    /// Equivalent of `UINavigationBar`.
    case navigationBar
    /// Equivalent of `UIKeyboard`.
    case keyboard
    /// Equivalent of user defined `XCUIElement` with `CGRectEdge` on which it appears.
    case other(element: XCUIElement, edge: CGRectEdge)

    /// Edge on which `XCUIElement` appears.
    var edge: CGRectEdge {
        switch self {
        case .navigationBar: return .minYEdge
        case .keyboard: return .maxYEdge
        case .other(_, let edge): return edge
        }
    }

    /// Finds `XCUIElement` depending on case.
    ///
    /// - Parameter app: XCUIAppliaction to search through, `XCUIApplication()` by default.
    /// - Returns: `XCUIElement` equivalent of enum case.
    ///

    func element(in app: XCUIApplication = XCUIApplication()) -> XCUIElement {
        switch self {
        case .navigationBar: return app.navigationBars.element
        case .keyboard: return app.keyboards.element
        case .other(let element, _): return element
        }
    }

    /// Calculates rect that reminds scrollable through substract overlaping part of `XCUIElement`.
    ///
    /// - Parameters:
    ///   - rect: CGRect that is overlapped.
    ///   - app: XCUIApplication in which overlapping element can be found.
    /// - Returns: Part of rect not overlapped by element.
    ///

    func overlapReminder(of rect: CGRect, in app: XCUIApplication, orientation: UIDeviceOrientation) -> CGRect {

        let overlappingElement = element(in: app)
        guard overlappingElement.exists else { return rect }

        let overlappingElementFrame: CGRect
        if case .keyboard = self {
            overlappingElementFrame = overlappingElement.frame(for: orientation, in: app)
        } else {
            overlappingElementFrame = overlappingElement.frame
        }
        let overlap: CGFloat

        switch edge {
        case .maxYEdge:
            overlap = rect.maxY - overlappingElementFrame.minY
        case .minYEdge:
            overlap = overlappingElementFrame.maxY - rect.minY
        default:
            return rect
        }

        return rect.divided(atDistance: max(overlap, 0),
                            from: edge).remainder
    }
}
