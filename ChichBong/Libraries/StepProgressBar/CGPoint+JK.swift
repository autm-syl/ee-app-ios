//
//  CGPoint+JK.swift
//  ChichBong
//
//  Created by Sylvanas on 4/14/21.
//

import Foundation

extension CGRect {
    /*
     * Makes a rect with the given center and diamater
     */
    static func make(center point: CGPoint, diameter: CGFloat) -> CGRect {
        let radius = diameter / 2.0
        let rect = CGRect(x: point.x - radius, y: point.y - radius, width: diameter, height: diameter)
        return rect
    }
}
