//
//  MotionManagerProtocol.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import Combine

protocol MotionManagerProtocol: ObservableObject {
    /// Access the `Acceleration` in which the user is accelerating
    var userAcceleration: Acceleration { get }
    var _userAcceleration: CurrentValueSubject<Acceleration, Never> { get }
    
    /// Access the `RotationRate` of the device.
    var rotationRate: RotationRate { get }
    var _rotationRate: CurrentValueSubject<RotationRate, Never> { get }
    
    /// The time passed since the last update to the motion
    var timeInterval: Double { get }
    
    /// Start monitoring the motion
    func start()
    
    /// Stop monitoring the motion
    func stop()
}

extension MotionManagerProtocol {
    var userAcceleration: Acceleration {
        get { self._userAcceleration.value }
        set { self._userAcceleration.value = newValue }
    }
    
    var rotationRate: RotationRate {
        get { self._rotationRate.value }
        set { self._rotationRate.value = newValue }
    }
}
