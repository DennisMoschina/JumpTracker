//
//  Attitude.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.11.22.
//

import Foundation

struct Attitude {
    var roll: Double
    var pitch: Double
    var yaw: Double
    
    var rotationMatrix: RotationMatrix {
        // TODO: impplement
        return RotationMatrix()
    }
    
    var quaternion: Quaternion {
        // TODO: impplement
        return Quaternion()
    }
    
    init(roll: Double = 0, pitch: Double = 0, yaw: Double = 0) {
        self.roll = roll
        self.pitch = pitch
        self.yaw = yaw
    }
}
