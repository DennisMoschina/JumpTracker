//
//  FilteredMotionManager.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import Combine


class FilteredMotionManager: MotionManagerProtocol {
    var _motion: CurrentValueSubject<Motion, Never> = CurrentValueSubject(Motion())

    var timeInterval: Double {
        self.motionManager.timeInterval
    }
    
    var _updating: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)

    private var motionManager: any MotionManagerProtocol

    private var accelFilterX: any Filter
    private var accelFilterY: any Filter
    private var accelFilterZ: any Filter

    private var motionCancellable: AnyCancellable?
    private var updatingCancellable: AnyCancellable?


    init(motionManager: any MotionManagerProtocol, accelFilterX: any Filter, accelFilterY: any Filter, accelFilterZ: any Filter) {
        self.motionManager = motionManager
        self.accelFilterX = accelFilterX
        self.accelFilterY = accelFilterY
        self.accelFilterZ = accelFilterZ
        
        self.updatingCancellable = motionManager._updating.sink { self.updating = $0 }

        self.motionCancellable = motionManager._motion.sink(receiveValue: { m in
            var motion: Motion = m
            
            let acceleration = motion.userAcceleration

            motion.userAcceleration = SIMDAcceleration(
                x: self.accelFilterX.filter(acceleration.x),
                y: self.accelFilterY.filter(acceleration.y),
                z: self.accelFilterZ.filter(acceleration.z)
            )
            self.motion = motion
        })
    }

    func start() {
        self.motionManager.start()
    }

    func stop() {
        self.motionManager.stop()
    }
}
