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
    @Published var historicRotationRate: [(acceleration: RotationRate, timestamp: Double)] = Array(repeating: (SIMDRotationRate(), 0.1), count: 30)
    @Published var historicAttitude: [(acceleration: any Attitude, timestamp: Double)] = Array(repeating: (SIMDAttitude(), 0.1), count: 30)
    
    @Published var motion: Motion = Motion()
    
    @Published var updating: Bool = false
    
    @Published var failed: Bool = false
    
    var reason: String = ""
    
    private var motionManager: any MotionManagerProtocol
    
    private var motionCancellable: AnyCancellable?
    
    private var updatingCancellable: AnyCancellable?
    private var failedCancellable: AnyCancellable?
    
    init(motionManager: any MotionManagerProtocol) {
        self.motionManager = motionManager
        self.updatingCancellable = motionManager._updating.receive(on: DispatchQueue.main).sink(receiveValue: { updating in
            self.updating = updating
        })
        self.motionCancellable = motionManager._motion.receive(on: DispatchQueue.main).sink(receiveValue: { motion in
            let acceleration = motion.userAcceleration
            self.userAcceleration = acceleration
            self.historicUserAccel.remove(at: 0)
            self.historicUserAccel.append((acceleration, (self.historicUserAccel.last?.timestamp ?? 0) + motion.timeInterval))
            self.historicRotationRate.remove(at: 0)
            self.historicRotationRate.append((motion.rotationRate, (self.historicRotationRate.last?.timestamp ?? 0) + motion.timeInterval))
            self.historicAttitude.remove(at: 0)
            self.historicAttitude.append((motion.attitude, (self.historicAttitude.last?.timestamp ?? 0) + motion.timeInterval))
            
            self.rotationRate = motion.rotationRate
            self.attitude = motion.attitude
            
            self.motion = motion
        })
    }
    
    func startMonitoring() async -> Bool {
        do {
            try await self.motionManager.start()
        } catch {
            DispatchQueue.main.async {
                self.reason = error.localizedDescription
                self.failed = true                
            }
            return false
        }
        return true
    }
    
    func stopMonitoring() {
        self.motionManager.stop()
    }
}
