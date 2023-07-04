//
//  AbsoluteDistance.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 11.12.22.
//

import Foundation

struct AbsoluteDistance: AdditiveArithmetic {
    static var zero: AbsoluteDistance = AbsoluteDistance(distance: 0)
    
    var distance: Double
    
    init(distance: Double = 0) {
        self.distance = distance
    }
    
    
    static func + (lhs: AbsoluteDistance, rhs: AbsoluteDistance) -> AbsoluteDistance {
        return AbsoluteDistance(distance: lhs.distance + rhs.distance)
    }
    
    static func - (lhs: AbsoluteDistance, rhs: AbsoluteDistance) -> AbsoluteDistance {
        return AbsoluteDistance(distance: lhs.distance - rhs.distance)
    }
}
