//
//  FilteredMotionManager.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import Combine


class FilteredMotionManager: MotionManagerProtocol {
    
    var _userAcceleration: CurrentValueSubject<Acceleration, Never> = CurrentValueSubject(Acceleration())
    
    var _rotationRate: CurrentValueSubject<RotationRate, Never> = CurrentValueSubject(RotationRate())

    var _attitude: CurrentValueSubject<Attitude, Never> = CurrentValueSubject(Attitude())
    
    var timeInterval: Double {
        self.motionManager.timeInterval
    }
    
    private var motionManager: any MotionManagerProtocol
    
    private var accelFilterX: any Filter
    private var accelFilterY: any Filter
    private var accelFilterZ: any Filter
    
    private var userAccelerationCancellable: AnyCancellable?
    private var rotationRateCancellable: AnyCancellable?
    private var attitudeCancellable: AnyCancellable?

    
    init(motionManager: any MotionManagerProtocol, accelFilterX: any Filter, accelFilterY: any Filter, accelFilterZ: any Filter) {
        self.motionManager = motionManager
        self.accelFilterX = accelFilterX
        self.accelFilterY = accelFilterY
        self.accelFilterZ = accelFilterZ
        
        self.userAccelerationCancellable = motionManager._userAcceleration.sink(receiveValue: { acceleration in
            self.userAcceleration = Acceleration(
                x: self.accelFilterX.filter(acceleration.x),
                y: self.accelFilterY.filter(acceleration.y),
                z: self.accelFilterZ.filter(acceleration.z)
            )
        })
        
        self.rotationRateCancellable = motionManager._rotationRate.sink(receiveValue: { rotationRate in
            self.rotationRate = rotationRate
        })
        
        self.attitudeCancellable = motionManager._attitude.sink(receiveValue: { attitude in
            self.attitude = attitude
        })
    }
    
    func start() {
        self.motionManager.start()
    }
    
    func stop() {
        self.motionManager.stop()
    }
}
