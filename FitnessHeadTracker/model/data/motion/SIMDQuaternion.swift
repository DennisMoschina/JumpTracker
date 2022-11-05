//
//  Quaternion.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.11.22.
//

import Foundation

struct SIMDQuaternion: Quaternion {
    var x: Double
    var y: Double
    var z: Double
    var w: Double
    
    init(x: Double = 0, y: Double = 0, z: Double = 0, w: Double = 0) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
    }
}
