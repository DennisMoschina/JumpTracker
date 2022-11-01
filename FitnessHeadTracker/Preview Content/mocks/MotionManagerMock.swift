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

    // TODO: use variable interval
    var timeInterval: Double = 0.1
    
    private var active: Bool = false
    
    
    func start() {
        self.active = true
    }
    
    func stop() {
        self.active = false
    }
    
    func update(acceleration: Acceleration = Acceleration(), rotationRate: RotationRate = RotationRate(), timeInterval: Double = 0.1) {
        if !self.active {
            return
        }
        
        self.userAcceleration = acceleration
        self.rotationRate = rotationRate
        self.timeInterval = timeInterval
    }
}
