//
// Created by Nick Teissler on 1/1/19
// Copyright © 2019 Nick Teissler. All rights reserved.

import UIKit

@IBDesignable
class PlayPauseButton: UIButton {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {

        // Green Background Circle
        UIColor.green.setFill()
        UIColor.black.setStroke()
        let greenCircle = UIBezierPath(ovalIn: bounds)
        greenCircle.fill()
        greenCircle.stroke()

        // Play Icon
        UIColor.black.setFill()
        let isosceles = UIBezierPath(isoscelesTringleIn: bounds, radians: .pi / 3.6)
        isosceles.fill()

        // Pause Icon
    }
}

private extension UIBezierPath {

    /// Draws a scalene triangles (two side lenghts equal) inside the given rectangle.
    /// The triagle is 'pointing' rightwards like a play-button icon.
    ///
    /// - Parameters:
    ///   - rect: The rect to inscribe the triangle in
    ///   - angle: The angle of the two equal angles of the isosceles triangle
    convenience init(isoscelesTringleIn rect: CGRect, radians: CGFloat) {

        let height = rect.width * 0.644
        let rightPoint = CGPoint(x: rect.width * 0.89, y: rect.midY)
        let base = tan(radians / 2.0) * height // 0.5 * the length of the isosceles full base


        let upperLeft = CGPoint(x: rightPoint.x - height, y: rightPoint.y - base)
        let lowerLeft = CGPoint(x: rightPoint.x - height, y: rightPoint.y + base)

        self.init()

        move(to: rightPoint)
        addLine(to: upperLeft)
        addLine(to: lowerLeft)
        close()
    }
}
