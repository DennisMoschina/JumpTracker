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
    @Published var attitude: Attitude = Attitude()
    
    @Published var historicUserAccel: [(acceleration: Acceleration, timestamp: Double)] = Array(repeating: (Acceleration(), 0.1), count: 30)
    
    var motionManager: any MotionManagerProtocol
    
    var userAccelerationCancellable: AnyCancellable?
    var rotationRateCancellable: AnyCancellable?
    var attitudeCancellable: AnyCancellable?
    
    init(motionManager: any MotionManagerProtocol) {
        self.motionManager = motionManager
        self.userAccelerationCancellable = motionManager._userAcceleration.sink(receiveValue: { acceleration in
            self.userAcceleration = acceleration
            self.historicUserAccel.remove(at: 0)
            self.historicUserAccel.append((acceleration, (self.historicUserAccel.last?.timestamp ?? 0) + self.motionManager.timeInterval))
        })
        self.rotationRateCancellable = motionManager._rotationRate.sink(receiveValue: { rotationRate in
            self.rotationRate = rotationRate
        })
        self.attitudeCancellable = motionManager._attitude.sink(receiveValue: { attitude in
            self.attitude = attitude
        })
    }
    
    func startMonitoring() {
        self.motionManager.start()
    }
    
    func stopMonitoring() {
        self.motionManager.stop()
    }
}
