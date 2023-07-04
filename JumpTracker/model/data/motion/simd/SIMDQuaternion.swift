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
        get { Double(self.simdVec.imag[0]) }
        set { self.simdVec.imag[0] = Float(newValue) }
    }
    var y: Double {
        get { Double(self.simdVec.imag[1]) }
        set { self.simdVec.imag[1] = Float(newValue) }
    }
    var z: Double {
        get { Double(self.simdVec.imag[2]) }
        set { self.simdVec.imag[2] = Float(newValue) }
    }
    var w: Double {
        get { Double(self.simdVec.real) }
        set { self.simdVec.real = Float(newValue) }
    }
    
    private var simdVec: simd_quatf
    
    init(simdVec: simd_float4) {
        self.simdVec = simd_quatf(vector: simdVec)
    }
    
    init(angle: Float, axis: simd_float3) {
        self.simdVec = simd_quatf(angle: angle, axis: axis)
    }
    
    init(from: simd_float3, to: simd_float3) {
        self.simdVec = simd_quatf(from: from, to: to)
    }
    
    init(x: Double = 0, y: Double = 0, z: Double = 0, w: Double = 0) {
        self.init(simdVec: simd_float4(x: Float(x), y: Float(y), z: Float(z), w: Float(w)))
    }
}
