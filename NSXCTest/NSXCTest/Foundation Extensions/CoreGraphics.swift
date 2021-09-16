import CoreGraphics

extension CGRect {

    /// Returns center point of the rectangle.
    var center: CGPoint {
        return CGPoint(x: midX, y: midY)
    }
}

extension CGPoint {

    /// Returns vector between two points.
    ///
    /// - Parameter point: Destination point.
    /// - Returns: Vectory between `self` and `point`.
    func vector(to point: CGPoint) -> CGVector {
        return CGVector(dx: point.x - x, dy: point.y - y)
    }
}
