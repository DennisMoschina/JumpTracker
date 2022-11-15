//
//  MotionViewModel.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import Combine

class MotionViewModel: ObservableObject {
    @Published var userAcceleration: Acceleration = SIMDAcceleration(x: 0, y: 0, z: 0)
    @Published var rotationRate: RotationRate = SIMDRotationRate(x: 0, y: 0, z: 0)
    @Published var attitude: any Attitude = SIMDAttitude()
    
    @Published var historicUserAccel: [(acceleration: Acceleration, timestamp: Double)] = Array(repeating: (SIMDAcceleration(), 0.1), count: 30)
    
    @Published var motion: Motion = Motion()
    
    private var motionManager: any MotionManagerProtocol
    
    private var motionCancellable: AnyCancellable?
    
    init(motionManager: any MotionManagerProtocol) {
        self.motionManager = motionManager
        self.motionCancellable = motionManager._motion.sink(receiveValue: { motion in
            let acceleration = motion.userAcceleration
            self.userAcceleration = acceleration
            self.historicUserAccel.remove(at: 0)
            self.historicUserAccel.append((acceleration, (self.historicUserAccel.last?.timestamp ?? 0) + motion.timeInterval))
            
            self.rotationRate = motion.rotationRate
            self.attitude = motion.attitude
            
            self.motion = motion
        })
    }
    
    func startMonitoring() {
        self.motionManager.start()
    }
    
    func stopMonitoring() {
        self.motionManager.stop()
    }
}
