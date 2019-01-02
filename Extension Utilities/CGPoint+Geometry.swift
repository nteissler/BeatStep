//
// Created by Nick Teissler on 1/2/19
// Copyright © 2019 Nick Teissler. All rights reserved.

import UIKit

extension CGPoint {

    /// - Parameter rect: The smallest rectangle that circumsribes the conceptual ellipse
    /// - Returns: `true` if the point is inside the ellipse, including boundaries, `false`
    ///   otherwise
    func withinEllipse(inscribedIn rect: CGRect) -> Bool {
        let xExpression = (x - rect.midX) ** 2 / rect.midX ** 2
        let yExpression = (y - rect.midY) ** 2 / rect.midY ** 2
        return xExpression + yExpression <= 1
    }
}


precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator **: PowerPrecedence
/// - Parameters:
///   - base: The base
///   - power: The power
/// - Returns: base raised to the power'th power.
func **(base: CGFloat, power: CGFloat) -> CGFloat {
    return pow(base, power)
}
