//
//  Attitude.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.11.22.
//

import Foundation

struct SIMDAttitude: Attitude {
    typealias Q = SIMDQuaternion
    typealias R = SIMDRotationMatrix
    
    var roll: Double
    var pitch: Double
    var yaw: Double
    
    var rotationMatrix: SIMDRotationMatrix {
        // TODO: impplement
        return SIMDRotationMatrix()
    }
    
    var quaternion: SIMDQuaternion {
        // TODO: impplement
        return SIMDQuaternion()
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
