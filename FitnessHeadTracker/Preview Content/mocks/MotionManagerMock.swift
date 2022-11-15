//
//  MotionManagerMock.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import Combine

class MotionManagerMock: NSObject, MotionManagerProtocol {
    var _motion: CurrentValueSubject<Motion, Never> = CurrentValueSubject(Motion())
    
    var timeInterval: Double {
        get { self.motion.timeInterval }
        set { self.motion.timeInterval = newValue }
    }
    
    private var active: Bool = false
    
    
    func start() {
        self.active = true
    }
    
    func stop() {
        self.active = false
    }
    
    func update(acceleration: Acceleration = SIMDAcceleration(), rotationRate: RotationRate = SIMDRotationRate(), attitude: any Attitude = SIMDAttitude(), timeInterval: Double = 0.1) {
        if !self.active {
            return
        }
        
        self.timeInterval = timeInterval
        self.userAcceleration = acceleration
        self.rotationRate = rotationRate
        self.attitude = attitude
    }
}
