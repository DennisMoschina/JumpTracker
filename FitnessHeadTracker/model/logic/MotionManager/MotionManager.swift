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

    var _motion: CurrentValueSubject<Motion, Never> = CurrentValueSubject(Motion())
    
    private var oldTimestamp: Double = -1
    
    private let manager: CMHeadphoneMotionManager = CMHeadphoneMotionManager()
    
    
    
    private override init() {
        super.init()
        self.manager.delegate = self
    }
    
    // MARK: - Methods
    
    /**
     * Start monitoring the motion updates.
     *
     * The updates are published by the {@link MotionManager#_motion} property.
     *
     * The data aquisition does not hapen in the main queue
     */
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
        
        self.manager.startDeviceMotionUpdates(to: OperationQueue()) { motion, error in
            if let motion {
                let timestamp = CACurrentMediaTime()
                self.timeInterval = self.oldTimestamp < 0 ? 0 : timestamp - self.oldTimestamp
                self.oldTimestamp = timestamp
                
                print("time since last update: \(self.timeInterval)")
                
                self.userAcceleration = motion.userAcceleration
                self.rotationRate = motion.rotationRate
                self.attitude = motion.attitude
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
