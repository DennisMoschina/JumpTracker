//
//  SIMDDistance.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 07.11.22.
//

import Foundation
import simd

struct SIMDDistance: Distance {
    internal static var zero: SIMDDistance = SIMDDistance(x: 0, y: 0, z: 0)
    
    var x: Double {
        get { self.simdVec.x }
        set { self.simdVec.x = newValue}
    }
    var y: Double {
        get { self.simdVec.y }
        set { self.simdVec.y = newValue}
    }
    var z: Double{
        get { self.simdVec.z }
        set { self.simdVec.z = newValue}
    }
    
    var simdVec: simd_double3
    
    init(simdVec: simd_double3) {
        self.simdVec = simdVec
    }
    
    init(x: Double = 0, y: Double = 0, z: Double = 0) {
        self.init(simdVec: simd_double3(x, y, z))
    }
    
    // MARK: static functions
    
    static func + (lhs: SIMDDistance, rhs: SIMDDistance) -> SIMDDistance {
        return SIMDDistance(simdVec: lhs.simdVec + rhs.simdVec)
    }
    
    static func - (lhs: SIMDDistance, rhs: SIMDDistance) -> SIMDDistance {
        return SIMDDistance(simdVec: lhs.simdVec - rhs.simdVec)
    }
    
    static func + (lhs: SIMDDistance, rhs: any Distance) -> SIMDDistance {
        var result: SIMDDistance = lhs
        result.simdVec.x += rhs.x
        result.simdVec.y += rhs.y
        result.simdVec.z += rhs.z
        
        return result
    }
    
    static func - (lhs: SIMDDistance, rhs: any Distance) -> SIMDDistance {
        var result: SIMDDistance = lhs
        result.simdVec.x -= rhs.x
        result.simdVec.y -= rhs.y
        result.simdVec.z -= rhs.z
        
        return result
    }
}
