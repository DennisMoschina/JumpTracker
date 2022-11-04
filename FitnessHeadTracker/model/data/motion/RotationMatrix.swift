//
//  RotationMatrix.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.11.22.
//

import Foundation

struct RotationMatrix {
    var m11: Double
    var m12: Double
    var m13: Double
    var m21: Double
    var m22: Double
    var m23: Double
    var m31: Double
    var m32: Double
    var m33: Double

    init(m11: Double = 0, m12: Double = 0, m13: Double = 0, m21: Double = 0, m22: Double = 0, m23: Double = 0, m31: Double = 0, m32: Double = 0, m33: Double = 0) {
        self.m11 = m11
        self.m12 = m12
        self.m13 = m13
        self.m21 = m21
        self.m22 = m22
        self.m23 = m23
        self.m31 = m31
        self.m32 = m32
        self.m33 = m33
    }
}
