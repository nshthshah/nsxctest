import Foundation
import UIKit

/// :nodoc:
public extension UIImage {

    func scaled(withScale scale: CGFloat = 0.5) -> UIImage {
        let size = CGSize(width: self.size.width * scale, height: self.size.height * scale)
        UIGraphicsBeginImageContextWithOptions(size, false, 0)
        draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        return image
    }
}
