//
//  Quaternion.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.11.22.
//

import Foundation
import simd

struct SIMDQuaternion: Quaternion {
    var x: Double {
        get { self.simdVec.x }
        set { self.simdVec.x = newValue }
    }
    var y: Double {
        get { self.simdVec.y }
        set { self.simdVec.y = newValue }
    }
    var z: Double {
        get { self.simdVec.z }
        set { self.simdVec.z = newValue }
    }
    var w: Double {
        get { self.simdVec.w }
        set { self.simdVec.w = newValue }
    }
    
    var simdVec: simd_double4
    
    init(simdVec: simd_double4) {
        self.simdVec = simdVec
    }
    
    init(x: Double = 0, y: Double = 0, z: Double = 0, w: Double = 0) {
        self.init(simdVec: simd_double4(x: x, y: y, z: z, w: w))
    }
}
