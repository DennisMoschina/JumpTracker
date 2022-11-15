//
//  MotionCoreDataRecorder.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 07.11.22.
//

import Foundation
import Combine
import CoreData

class MotionCoreDataRecorder {
    let persistenceController: PersistenceController
    let context: NSManagedObjectContext
    
    var runningRecording: Recording?
    
    private var motionManager: any MotionManagerProtocol
    private var motionCancellable: AnyCancellable?
    
    init(persistenceController: PersistenceController = PersistenceController.shared,
         context: NSManagedObjectContext? = nil,
         motionManager: any MotionManagerProtocol = MotionManager.singleton) {
        
        self.persistenceController = persistenceController
        
        if let context {
            self.context = context
        } else {
            self.context = self.persistenceController.container.newBackgroundContext()
        }
        
        self.motionManager = motionManager
        
        self.motionCancellable = motionManager._motion.sink(receiveValue: { motion in
            self.addToRecording(acceleration: motion.userAcceleration,
                                rotationRate: motion.rotationRate,
                                attitude: motion.attitude,
                                timeInterval: motion.timeInterval)
        })
    }
    
    func startRecording() {
        self.runningRecording = Recording(context: self.context)
        self.runningRecording?.startTime = Date()
    }
    
    func endRecording() {
        if self.context.hasChanges {
            do {
                try self.context.save()
            } catch {
                print("Error while saving context")
            }
            
            self.runningRecording = nil
        }
    }
    
    func addToRecording(acceleration: Acceleration, rotationRate: RotationRate, attitude: any Attitude, timeInterval: Double) {
        let motion = CDMotion(context: context)
        motion.timeInterval = timeInterval
        
        let cdAcceleration: CDAcceleration = CDAcceleration(context: self.context)
        cdAcceleration.x = acceleration.x
        cdAcceleration.y = acceleration.y
        cdAcceleration.z = acceleration.z
        
        let cdRotationRate: CDRotationRate = CDRotationRate(context: self.context)
        cdRotationRate.x = rotationRate.x
        cdRotationRate.y = rotationRate.y
        cdRotationRate.z = rotationRate.z
        
        let cdAttitude: CDAttitude = CDAttitude(context: self.context)
        cdAttitude.roll = attitude.roll
        cdAttitude.pitch = attitude.pitch
        cdAttitude.yaw = attitude.yaw
        
        motion.attitude = cdAttitude
        motion.rotationRate = cdRotationRate
        motion.userAcceleration = cdAcceleration
        
        self.runningRecording?.addToMotions(motion)
    }
}
