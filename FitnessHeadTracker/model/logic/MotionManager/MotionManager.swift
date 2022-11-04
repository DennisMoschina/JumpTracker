//
//  MotionManager.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import Combine

import CoreMotion
import SwiftUI


class MotionManager: NSObject, MotionManagerProtocol, CMHeadphoneMotionManagerDelegate {
    
    public static let singleton: MotionManager = MotionManager()
    
    var _userAcceleration: CurrentValueSubject<Acceleration, Never> = CurrentValueSubject(Acceleration())
    
    var _rotationRate: CurrentValueSubject<RotationRate, Never> = CurrentValueSubject(RotationRate())

    var _attitude: CurrentValueSubject<Attitude, Never> = CurrentValueSubject(Attitude())
    
    var timeInterval: Double = 0
    
    private var oldTimestamp: Double = -1
    
    private let manager: CMHeadphoneMotionManager = CMHeadphoneMotionManager()
    
    
    
    private override init() {
        super.init()
        self.manager.delegate = self
    }
    
    // MARK: - Methods
    
    func start() {
        print("Available: \(self.manager.isDeviceMotionAvailable)")
        var authStatus: String
        switch CMHeadphoneMotionManager.authorizationStatus() {
        case .authorized:
            authStatus = "authorized"
        case .restricted:
            authStatus = "restricted"
        case .denied:
            authStatus = "denied"
        case .notDetermined:
            authStatus = "not determined"
        @unknown default:
            authStatus = "unknown \(CMHeadphoneMotionManager.authorizationStatus())"
        }
        
        print("Authorization: \(authStatus)")
        
        self.manager.startDeviceMotionUpdates(to: OperationQueue.main) { motion, error in
            if let motion {
                let timestamp = CACurrentMediaTime()
                self.timeInterval = self.oldTimestamp < 0 ? 0 : timestamp - self.oldTimestamp
                self.oldTimestamp = timestamp
                
                print("time since last update: \(self.timeInterval)")
                
                let userAccel = motion.userAcceleration
                self.userAcceleration = Acceleration(x: userAccel.x, y: userAccel.y, z: userAccel.z)
                let rotationRate = motion.rotationRate
                self.rotationRate = RotationRate(x: rotationRate.x, y: rotationRate.y, z: rotationRate.z)
                let attitude = motion.attitude
                self.attitude = Attitude(roll: attitude.roll, pitch: attitude.pitch, yaw: attitude.yaw)
            }
            if let error {
                print(error)
            }
        }
        print("Active: \(self.manager.isDeviceMotionActive)")
    }
    
    func stop() {
        self.manager.stopDeviceMotionUpdates()
        self.oldTimestamp = -1
    }
    
    // MARK: - Delegate Methods
    
    internal func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        print("connected Headphones")
    }
    
    internal func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        print("disconnected Headphones")
    }
}
