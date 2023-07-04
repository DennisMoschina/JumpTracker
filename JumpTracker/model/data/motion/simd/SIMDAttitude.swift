//
//  Attitude.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.11.22.
//

import Foundation
import simd

struct SIMDAttitude: Attitude {
    typealias Q = SIMDQuaternion
    typealias R = SIMDRotationMatrix
    
    var roll: Double
    var pitch: Double
    var yaw: Double
    
    var rotationMatrix: SIMDRotationMatrix {
        // TODO: impplement
        return SIMDRotationMatrix(simdVec: double3x3.init(diagonal: simd_double3(repeating: 1)))
    }
    
    var quaternion: SIMDQuaternion {
        let cr = cos(roll * 0.5);
        let sr = sin(roll * 0.5);
        let cp = cos(pitch * 0.5);
        let sp = sin(pitch * 0.5);
        let cy = cos(yaw * 0.5);
        let sy = sin(yaw * 0.5);

        let w = cr * cp * cy + sr * sp * sy;
        let x = sr * cp * cy - cr * sp * sy;
        let y = cr * sp * cy + sr * cp * sy;
        let z = cr * cp * sy - sr * sp * cy;

        return SIMDQuaternion(x: x, y: y, z: z, w: w)
    }
    
    init(roll: Double = 0, pitch: Double = 0, yaw: Double = 0) {
        self.roll = roll
        self.pitch = pitch
        self.yaw = yaw
    }
    
    
    func multiply(byInverseOf attitude: SIMDAttitude) {
        // TODO: implement
    }
}
