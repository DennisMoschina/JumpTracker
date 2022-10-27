//
//  Distance.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation

struct Distance: AdditiveArithmetic {
    static var zero: Distance = Distance(x: 0, y: 0, z: 0)
    
    var x: Double
    var y: Double
    var z: Double
    
    init(x: Double = 0, y: Double = 0, z: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    
    static func + (lhs: Distance, rhs: Distance) -> Distance {
        return Distance(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }
    
    static func - (lhs: Distance, rhs: Distance) -> Distance {
        return Distance(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
    }
}
