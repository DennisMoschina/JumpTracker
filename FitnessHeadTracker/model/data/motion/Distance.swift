//
//  Distance.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation

protocol Distance: AdditiveArithmetic {
    var x: Double { get set }
    var y: Double { get set }
    var z: Double { get set }
    
    static func + (lhs: Self, rhs: any Distance) -> Self
    static func - (lhs: Self, rhs: any Distance) -> Self
}
