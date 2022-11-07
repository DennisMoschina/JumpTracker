//
//  RotationMatrix.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.11.22.
//

import Foundation
import simd

struct SIMDRotationMatrix: RotationMatrix {
    var m11: Double {
        get { self.simdVec.columns.0[0] }
        set { self.simdVec.columns.0[0] = newValue }
    }
    var m12: Double {
        get { self.simdVec.columns.0[1] }
        set { self.simdVec.columns.0[1] = newValue }
    }
    var m13: Double {
        get { self.simdVec.columns.0[2] }
        set { self.simdVec.columns.0[2] = newValue }
    }
    var m21: Double {
        get { self.simdVec.columns.1[0] }
        set { self.simdVec.columns.1[0] = newValue }
    }
    var m22: Double {
        get { self.simdVec.columns.1[1] }
        set { self.simdVec.columns.1[1] = newValue }
    }
    var m23: Double {
        get { self.simdVec.columns.1[2] }
        set { self.simdVec.columns.1[2] = newValue }
    }
    var m31: Double {
        get { self.simdVec.columns.2[0] }
        set { self.simdVec.columns.2[0] = newValue }
    }
    var m32: Double {
        get { self.simdVec.columns.2[1] }
        set { self.simdVec.columns.2[1] = newValue }
    }
    var m33: Double {
        get { self.simdVec.columns.2[2] }
        set { self.simdVec.columns.2[2] = newValue }
    }
    
    var simdVec: double3x3
    
    init(simdVec: double3x3) {
        self.simdVec = simdVec
    }

    init(m11: Double = 0, m12: Double = 0, m13: Double = 0, m21: Double = 0, m22: Double = 0, m23: Double = 0, m31: Double = 0, m32: Double = 0, m33: Double = 0) {
        self.init(simdVec: double3x3(rows: [
            simd_double3(m11, m12, m13),
            simd_double3(m21, m22, m23),
            simd_double3(m31, m32, m33)
        ]))
    }
}
