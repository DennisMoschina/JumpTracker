//
//  Speed.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 31.10.22.
//

import Foundation
import simd

struct SIMDSpeed: Speed {
    internal static var zero: SIMDSpeed = SIMDSpeed(x: 0, y: 0, z: 0)
    
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
    
    static func + (lhs: SIMDSpeed, rhs: SIMDSpeed) -> SIMDSpeed {
        return SIMDSpeed(simdVec: lhs.simdVec + rhs.simdVec)
    }
    
    static func - (lhs: SIMDSpeed, rhs: SIMDSpeed) -> SIMDSpeed {
        return SIMDSpeed(simdVec: lhs.simdVec - rhs.simdVec)
    }
    
    static func + (lhs: SIMDSpeed, rhs: any Speed) -> SIMDSpeed {
        var result: SIMDSpeed = lhs
        result.simdVec.x += rhs.x
        result.simdVec.y += rhs.y
        result.simdVec.z += rhs.z
        
        return result
    }
    
    static func - (lhs: SIMDSpeed, rhs: any Speed) -> SIMDSpeed {
        var result: SIMDSpeed = lhs
        result.simdVec.x -= rhs.x
        result.simdVec.y -= rhs.y
        result.simdVec.z -= rhs.z
        
        return result
    }
}
