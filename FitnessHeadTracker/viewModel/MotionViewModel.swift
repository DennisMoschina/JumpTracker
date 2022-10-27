//
//  MotionViewModel.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import Combine

class MotionViewModel: ObservableObject {
    @Published var userAcceleration: Acceleration = Acceleration(x: 0, y: 0, z: 0)
    @Published var rotationRate: RotationRate = RotationRate(x: 0, y: 0, z: 0)
    
    var motionManager: any MotionManagerProtocol
    
    var userAccelerationCancellable: AnyCancellable?
    var rotationRateCancellable: AnyCancellable?
    var headingCancellable: AnyCancellable?
    
    init(motionManager: any MotionManagerProtocol) {
        self.motionManager = motionManager
        self.userAccelerationCancellable = motionManager._userAcceleration.sink(receiveValue: { acceleration in
            self.userAcceleration = acceleration
        })
        self.rotationRateCancellable = motionManager._rotationRate.sink(receiveValue: { rotationRate in
            self.rotationRate = rotationRate
        })
    }
    
    func startMonitoring() {
        self.motionManager.start()
    }
    
    func stopMonitoring() {
        self.motionManager.stop()
    }
}
