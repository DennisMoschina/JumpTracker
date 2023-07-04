//
//  Speed.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 06.11.22.
//

import Foundation

protocol Speed: AdditiveArithmetic, Equatable {
    var x: Double { get set }
    var y: Double { get set }
    var z: Double { get set }
    
    static func + (lhs: Self, rhs: any Speed) -> Self
    static func - (lhs: Self, rhs: any Speed) -> Self
}

extension Speed {
    static func == (lhs: Self, rhs: any Speed) -> Bool {
        return lhs.x == rhs.x
        && lhs.y == rhs.y
        && lhs.z == rhs.z
    }
}
