//
//  Heading.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 01.11.22.
//

import Foundation

/**
 * This struct represents the direction something is heading at in a 3-dimensional space.
 */
struct Heading: AdditiveArithmetic {
    internal static var zero: Heading = Heading(x: 0, y: 0, z: 0)
    
    /// The x direction somehting is heading (from 0 to 2π)
    var x: Double
    /// The y direction somehting is heading (from 0 to 2π)
    var y: Double
    /// The z direction somehting is heading (from 0 to 2π)
    var z: Double
    
    init(x: Double = 0, y: Double = 0, z: Double = 0) {
        self.x = x.truncatingRemainder(dividingBy: 2 * .pi)
        self.y = y.truncatingRemainder(dividingBy: 2 * .pi)
        self.z = z.truncatingRemainder(dividingBy: 2 * .pi)
    }
    
    
    static func + (lhs: Heading, rhs: Heading) -> Heading {
        return Heading(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    static func - (lhs: Heading, rhs: Heading) -> Heading {
        return Heading(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
}
