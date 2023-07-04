//
//  Motion.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 13.11.22.
//

import Foundation

struct Motion {
    var userAcceleration: Acceleration
    var rotationRate: RotationRate
    var attitude: any Attitude
    
    var timeInterval: Double
    
    init(userAcceleration: Acceleration = SIMDAcceleration(),
         rotationRate: RotationRate = SIMDRotationRate(),
         attitude: any Attitude = SIMDAttitude(),
         timeInterval: Double = 0.1) {
        
        self.userAcceleration = userAcceleration
        self.rotationRate = rotationRate
        self.attitude = attitude
        self.timeInterval = timeInterval
    }
}
