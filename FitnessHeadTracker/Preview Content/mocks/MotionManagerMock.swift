//
//  MotionManagerMock.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import Combine

class MotionManagerMock: NSObject, MotionManagerProtocol {
    
    var _userAcceleration: CurrentValueSubject<Acceleration, Never> = CurrentValueSubject(Acceleration())
    
    var _rotationRate: CurrentValueSubject<RotationRate, Never> = CurrentValueSubject(RotationRate())
    
    var _attitude: CurrentValueSubject<Attitude, Never> = CurrentValueSubject(Attitude())

    var timeInterval: Double = 0.1
    
    private var active: Bool = false
    
    
    func start() {
        self.active = true
    }
    
    func stop() {
        self.active = false
    }
    
    func update(acceleration: Acceleration = Acceleration(), rotationRate: RotationRate = RotationRate(), attitude: Attitude = Attitude(), timeInterval: Double = 0.1) {
        if !self.active {
            return
        }
        
        self.timeInterval = timeInterval
        self.userAcceleration = acceleration
        self.rotationRate = rotationRate
        self.attitude = attitude
    }
}
