//
//  Acceleration.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import simd

struct SIMDAcceleration: Acceleration {
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
}
