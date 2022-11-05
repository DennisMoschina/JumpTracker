//
//  MotionBasedDistanceTracker.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import Combine

class MotionBasedDistanceTracker: DistanceTrackerProtocol {
    var _distance: CurrentValueSubject<Distance, Never> = CurrentValueSubject(Distance())
    
    private var motionManager: any MotionManagerProtocol
    
    private var userAccelerationCancellable: AnyCancellable?
    private var oldAcceleration: Acceleration = SIMDAcceleration()
    
    
    init(motionManager: any MotionManagerProtocol) {
        self.motionManager = motionManager
        self.userAccelerationCancellable = motionManager._userAcceleration.sink(receiveValue: { acceleration in
            if self.motionManager.timeInterval > 0.2 {
                print("discarded measurement due to taking too long to measure")
                return
            }
            
            self.distance += self.calculateDistanceChange(with: acceleration)
            self.oldAcceleration = acceleration
        })
    }
    
    func calculateDistanceChange(with acceleration: Acceleration) -> Distance {
        //FIXME: does not work, since it anticipates constant acceleration
        var distanceChange: Distance = Distance()
        
        let dt: Double = self.motionManager.timeInterval
        distanceChange.x = 0.5 * (acceleration.x + self.oldAcceleration.x) * dt
        distanceChange.y = 0.5 * (acceleration.y + self.oldAcceleration.y) * dt
        distanceChange.z = 0.5 * (acceleration.z + self.oldAcceleration.z) * dt
        
        return distanceChange
    }
}
