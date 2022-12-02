//
//  MotionManagerProtocol.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import Combine

protocol MotionManagerProtocol: ObservableObject {
    /// Access the `Acceleration` in which the device is accelerating
    var userAcceleration: Acceleration { get }
    
    /// Access the `RotationRate` of the device.
    var rotationRate: RotationRate { get }
    
    /// Access the `Attitude` of the device
    var attitude: any Attitude { get }
    
    var motion: Motion { get set }
    var _motion: CurrentValueSubject<Motion, Never> { get }
    
    /// Indicate that the Device motion updates are running
    var updating: Bool { get }
    var _updating: CurrentValueSubject<Bool, Never> { get }
    
    /// The time passed since the last update to the motion
    var timeInterval: Double { get }
    
    /// Start monitoring the motion
    func start()
    
    /// Stop monitoring the motion
    func stop()
}

extension MotionManagerProtocol {
    var userAcceleration: Acceleration {
        get { self.motion.userAcceleration }
        set { self.motion.userAcceleration = newValue }
    }
    
    var rotationRate: RotationRate {
        get { self.motion.rotationRate }
        set { self.motion.rotationRate = newValue }
    }
    
    var attitude: any Attitude {
        get { self.motion.attitude }
        set { self.motion.attitude = newValue }
    }
    
    var motion: Motion {
        get { self._motion.value }
        set { self._motion.value = newValue }
    }
    
    var timeInterval: Double {
        get { self.motion.timeInterval }
        set { self.motion.timeInterval = newValue }
    }
    
    var updating: Bool {
        get { self._updating.value }
        set { self._updating.value = newValue }
    }
}
