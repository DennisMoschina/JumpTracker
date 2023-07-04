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
    private static let TIME_OUT_TIME = 5
    
    public static let singleton: MotionManager = MotionManager()

    var _motion: CurrentValueSubject<Motion, Never> = CurrentValueSubject(Motion())
    
    private var oldTimestamp: TimeInterval = -1
    
    private let manager: CMHeadphoneMotionManager = CMHeadphoneMotionManager()
    
    var _updating: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    var _failed: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    
    var reason: String = ""
    
    private var startedTimestamp: CFTimeInterval = -1
    
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
    func start() async {
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
        
        switch CMHeadphoneMotionManager.authorizationStatus() {
        case .restricted, .denied, .notDetermined:
            self.failed = true
            self.reason = "Missing authorization"
            return
        default:
            break
        }
        
        
        self.startedTimestamp = CACurrentMediaTime()
        
        self.manager.startDeviceMotionUpdates(to: OperationQueue()) { motion, error in
            if let motion {
                let timestamp = motion.timestamp
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
        
        while ((!self.manager.isDeviceMotionActive || self.oldTimestamp < 0) && CACurrentMediaTime() < self.startedTimestamp + Double(Self.TIME_OUT_TIME)) {
            await Task.yield()
        }
        
        print("Active: \(self.manager.isDeviceMotionActive)")
        
        if !(self.manager.isDeviceMotionActive && self.oldTimestamp > 0) {
            self.reason = "Could not activate in time, make sure AirPods are connected"
            self.failed = true
            self.stop()
            return
        }
        self.updating = true
    }
    
    func stop() {
        self.updating = false
        self.manager.stopDeviceMotionUpdates()
        self.oldTimestamp = -1
    }
    
    // MARK: - Delegate Methods
    
    internal func headphoneMotionManagerDidConnect(_ manager: CMHeadphoneMotionManager) {
        print("connected Headphones")
    }
    
    internal func headphoneMotionManagerDidDisconnect(_ manager: CMHeadphoneMotionManager) {
        print("disconnected Headphones")
        if self.updating {
            self.failed = true
            self.reason = "Headphones disconnected"
            self.updating = false            
        }
    }
}
