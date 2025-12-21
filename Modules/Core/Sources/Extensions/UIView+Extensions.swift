import UIKit

public extension UIView {
    /// Add subviews and automatically set translatesAutoresizingMaskIntoConstraints = false
    func addSubviews(_ views: UIView...) {
        views.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    /// Add shadow to view
    func addShadow(
        color: UIColor = .black,
        opacity: Float = 0.1,
        offset: CGSize = CGSize(width: 0, height: 2),
        radius: CGFloat = 4
    ) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offset
        layer.shadowRadius = radius
        layer.masksToBounds = false
    }
    
    /// Remove shadow
    func removeShadow() {
        layer.shadowColor = nil
        layer.shadowOpacity = 0
        layer.shadowOffset = .zero
        layer.shadowRadius = 0
    }
    
    /// Create border with corner radius
    func setBorder(
        width: CGFloat = 1.0,
        color: UIColor = .separator,
        cornerRadius: CGFloat = 0
    ) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
        layer.cornerRadius = cornerRadius
    }
    
    /// Round corners
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(
            roundedRect: bounds,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

