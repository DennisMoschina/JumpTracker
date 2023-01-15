//
//  FilteredMotionManager.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import Combine


class FilteredMotionManager: MotionManagerProtocol {
    var _failed: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    var reason: String = ""
    
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
    private var failedCancellable: AnyCancellable?


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
        self.failedCancellable = motionManager._failed.sink(receiveValue: { failed in
            self.failed = failed
            self.reason = self.motionManager.reason
        })
    }

    func start() async {
        await self.motionManager.start()
    }

    func stop() {
        self.motionManager.stop()
    }
}
