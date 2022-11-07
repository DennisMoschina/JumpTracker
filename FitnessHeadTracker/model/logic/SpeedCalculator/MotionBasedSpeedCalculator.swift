//
//  MotionBasedSpeedCalculator.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 31.10.22.
//

import Foundation
import Combine
import simd

class MotionBasedSpeedCalculator: ObservableObject, SpeedCalculatorProtocol {
    var _speed: CurrentValueSubject<any Speed, Never> = CurrentValueSubject(SIMDSpeed.zero)
    
    private var motionManager: any MotionManagerProtocol
    
    private var userAccelerationCancellable: AnyCancellable?
    
    
    init(motionManager: any MotionManagerProtocol) {
        self.motionManager = motionManager
        self.userAccelerationCancellable = motionManager._userAcceleration.sink(receiveValue: { acceleration in
            if self.motionManager.timeInterval > 0.2 {
                print("discarded measurement due to taking too long to measure")
                return
            }
            self.speed = self.speed as! SIMDSpeed + self.calculateSpeedChange(with: acceleration, attitude: self.motionManager.attitude, timeInterval: self.motionManager.timeInterval)
        })
    }
    
    private func calculateSpeedChange(with acceleration: Acceleration, attitude: any Attitude, timeInterval: Double) -> any Speed {
        let simdDirectiveAccel: simd_double3 = double3x3(attitude.rotationMatrix) * simd_double3(acceleration)
        
        let simdSpeed: simd_double3 = timeInterval * simdDirectiveAccel
        
        return SIMDSpeed(simdVec: simdSpeed)
    }
}
