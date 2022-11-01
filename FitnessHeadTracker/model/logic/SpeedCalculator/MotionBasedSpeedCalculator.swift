//
//  MotionBasedSpeedCalculator.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 31.10.22.
//

import Foundation
import Combine

class MotionBasedSpeedCalculator: ObservableObject, SpeedCalculatorProtocol {
    var _speed: CurrentValueSubject<Speed, Never> = CurrentValueSubject(Speed.zero)
    
    private var motionManager: any MotionManagerProtocol
    
    private var userAccelerationCancellable: AnyCancellable?
    
    
    init(motionManager: any MotionManagerProtocol) {
        self.motionManager = motionManager
        self.userAccelerationCancellable = motionManager._userAcceleration.sink(receiveValue: { acceleration in
            if self.motionManager.timeInterval > 0.2 {
                print("discarded measurement due to taking too long to measure")
                return
            }
            
            self.speed += self.calculateSpeedChange(with: acceleration)
        })
    }
    
    func calculateSpeedChange(with acceleration: Acceleration) -> Speed {
        return Speed(
            x: self.motionManager.timeInterval * self.motionManager.userAcceleration.x,
            y: self.motionManager.timeInterval * self.motionManager.userAcceleration.y,
            z: self.motionManager.timeInterval * self.motionManager.userAcceleration.z
        )
    }
}
