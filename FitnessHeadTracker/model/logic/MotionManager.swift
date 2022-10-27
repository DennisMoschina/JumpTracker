//
//  MotionManager.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import Combine

import CoreMotion


class MotionManager: NSObject, MotionManagerProtocol, CMHeadphoneMotionManagerDelegate {
    
    private let manager: CMHeadphoneMotionManager = CMHeadphoneMotionManager()
    
    var _userAcceleration: CurrentValueSubject<Acceleration, Never> = CurrentValueSubject(Acceleration(x: 0, y: 0, z: 0))
    
    var _rotationRate: CurrentValueSubject<RotationRate, Never> = CurrentValueSubject(RotationRate(x: 0, y: 0, z: 0))
    
    
    override init() {
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
                let userAccel = motion.userAcceleration
                self.userAcceleration = Acceleration(x: userAccel.x, y: userAccel.y, z: userAccel.z)
                let rotationRate = motion.rotationRate
                self.rotationRate = RotationRate(x: rotationRate.x, y: rotationRate.y, z: rotationRate.z)
            }
            if let error {
                print(error)
            }
        }
        print("Active: \(self.manager.isDeviceMotionActive)")
    }
    
    func stop() {
        self.manager.stopDeviceMotionUpdates()
    }
    
    // MARK: - Delegate Methods
    
    internal func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        print("connected Headphones")
    }
    
    internal func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        print("disconnected Headphones")
    }
}
