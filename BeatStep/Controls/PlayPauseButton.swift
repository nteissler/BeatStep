//
// Created by Nick Teissler on 1/1/19
// Copyright © 2019 Nick Teissler. All rights reserved.

import UIKit

@IBDesignable
class PlayPauseButton: UIButton {

    enum PlaybackState {
        case play, pause

        fileprivate mutating func toggle() {
            self = self == .play ? .pause : .play
        }
    }
    private var playbackState: PlaybackState = .play

    init(play: @escaping () -> Void, pause: @escaping () -> Void) {
        super.init(frame: .zero)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    // MARK: - Button Dynamic Appearance Configuration
    private func commonInit() {
        addTarget(self, action: #selector(touchDown), for: .touchDown)
        addTarget(self, action: #selector(touchUp), for: .touchUpInside)
        addTarget(self, action: #selector(touchUp), for: .touchUpOutside)
        addTarget(self, action: #selector(toggleState), for: .touchUpInside)
    }

    @objc private func touchDown() {
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.1, delay: 0, animations: {
            self.layer.setAffineTransform(CGAffineTransform(scaleX: 0.95, y: 0.95))
        }, completion: { _ in
            self.setNeedsDisplay()
        })

    }

    @objc private func touchUp() {
        layer.setAffineTransform(.identity)
        setNeedsDisplay()
    }


    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return point.withinEllipse(inscribedIn: bounds)
    }

    @objc private func toggleState(sender: UIButton, event: UIEvent) {
        // GOTCHA: Sometimes .touchUpInside will trigger if the user slides and removes their finger
        // from the bounds fast enough. We don't want that behavior.
        guard event.allTouches?.contains(where: { self.bounds.contains($0.location(in: self)) }) ?? false else {
            return
        }
        playbackState.toggle()
    }

    // MARK: - Drawing
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let greenShade: UIColor
        let whiteShade: UIColor

        switch state {
        case .normal:
            greenShade = UIColor(named: "GreenEnabled")!
            whiteShade = .white
        default:
            greenShade = UIColor(named: "GreenDepressed")!
            whiteShade = .lightGray
        }
        // Green Background Circle
        let insetBounds = self.bounds.insetBy(dx: 3, dy: 3)
        greenShade.setFill()
        // Try to match the transluscent tab bar to the stroke color:
        // https://developer.apple.com/library/archive/qa/qa1808/_index.html
        UIColor(named: "ThemeGray")!.setStroke()
        let greenCircle = UIBezierPath(ovalIn: insetBounds)
        greenCircle.fill()
        greenCircle.stroke()

        switch playbackState {
        case .play:
            whiteShade.set()
            let isosceles = UIBezierPath(isoscelesTringleIn: bounds, radians: .pi / 3.6) // 50 degrees
            isosceles.fill()
            isosceles.stroke()
        case .pause:
            whiteShade.set()
            let (rect1, rect2) = UIBezierPath.twoRectangles(in: bounds, radians: .pi / 3.6)
            [rect1, rect2].forEach { $0.fill() }
        }
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
        let horizontalShift: CGFloat = -5 // translate the triangle along the X-axis for centering
        let height = rect.width * 0.5152
        let endpoint = rect.width * 0.89 + horizontalShift
        let rightPoint = CGPoint(x: endpoint, y: rect.midY)
        let base = tan(radians / 2.0) * height // 0.5 * the length of the isosceles full base


        let upperLeft = CGPoint(x: rightPoint.x - height, y: rightPoint.y - base)
        let lowerLeft = CGPoint(x: rightPoint.x - height, y: rightPoint.y + base)

        self.init()
        lineCapStyle = .round
        lineJoinStyle = .round
        miterLimit = 100
        lineWidth = 6

        move(to: rightPoint)
        addLine(to: upperLeft)
        addLine(to: lowerLeft)
        close()
    }

    static func twoRectangles(in rect: CGRect, radians: CGFloat) -> (UIBezierPath, UIBezierPath) {
        let h = tan(radians / 2.0) * 2.0 * rect.width * 0.5152
        let w = rect.width * 0.2
        let size = CGSize(width: w, height: h)

        let topYCoord = (rect.height - h) / 2.0
        let rect1Origin = CGPoint(x: w + 0.2 * w, y: topYCoord)
        let rect2Origin = CGPoint(x: w * 3 - 0.2 * w, y: topYCoord)

        let rect1 = CGRect(origin: rect1Origin, size: size)
        let rect2 = CGRect(origin: rect2Origin, size: size)

        return (UIBezierPath.init(roundedRect: rect1, cornerRadius: 2.0),
                UIBezierPath.init(roundedRect: rect2, cornerRadius: 2.0))
    }
}
