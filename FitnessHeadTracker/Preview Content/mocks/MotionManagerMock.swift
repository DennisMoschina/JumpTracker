//
//  MotionManagerMock.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import Combine

class MotionManagerMock: NSObject, MotionManagerProtocol {
    
    var _userAcceleration: CurrentValueSubject<Acceleration, Never> = CurrentValueSubject(SIMDAcceleration())
    
    var _rotationRate: CurrentValueSubject<RotationRate, Never> = CurrentValueSubject(SIMDRotationRate())
    
    var _attitude: CurrentValueSubject<any Attitude, Never> = CurrentValueSubject(SIMDAttitude())

    var timeInterval: Double = 0.1
    
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
