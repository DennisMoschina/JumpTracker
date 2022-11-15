//
//  MotionBasedDistanceTracker.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import Combine

class MotionBasedDistanceTracker: DistanceTrackerProtocol {
    var _distance: CurrentValueSubject<any Distance, Never> = CurrentValueSubject(SIMDDistance.zero)
    
    private var motionManager: any MotionManagerProtocol
    
    private var userAccelerationCancellable: AnyCancellable?
    private var oldAcceleration: Acceleration = SIMDAcceleration()
    
    
    init(motionManager: any MotionManagerProtocol) {
        self.motionManager = motionManager
        self.userAccelerationCancellable = motionManager._motion.sink(receiveValue: { motion in
            if motion.timeInterval > 0.2 {
                print("discarded measurement due to taking too long to measure")
                return
            }
            
            self.distance = self.distance as! SIMDDistance + self.calculateDistanceChange(with: motion.userAcceleration)
            self.oldAcceleration = motion.userAcceleration
        })
    }
    
    func calculateDistanceChange(with acceleration: Acceleration) -> any Distance {
        //FIXME: does not work, since it anticipates constant acceleration
        var distanceChange: any Distance = SIMDDistance()
        
        let dt: Double = self.motionManager.timeInterval
        distanceChange.x = 0.5 * (acceleration.x + self.oldAcceleration.x) * dt
        distanceChange.y = 0.5 * (acceleration.y + self.oldAcceleration.y) * dt
        distanceChange.z = 0.5 * (acceleration.z + self.oldAcceleration.z) * dt
        
        return distanceChange
    }
}
