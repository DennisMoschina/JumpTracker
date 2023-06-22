//
//  DataRecorder.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 21.06.23.
//

import Foundation
import CoreData

class DataRecorder {
    private let persistenceController: PersistenceController
    private var context: NSManagedObjectContext {
        self.persistenceController.container.viewContext
    }
    
    private var runningRecording: Recording?

    init(persistenceController: PersistenceController) {
        self.persistenceController = persistenceController
    }
    
    func startRecording() {
        self.runningRecording = Recording(context: self.context)
        self.runningRecording?.startTime = Date()
        self.runningRecording?.name = UUID().uuidString
    }
    
    func stopRecording() {
        if self.context.hasChanges {
            self.persistenceController.save()
        }
        self.runningRecording = nil
    }
    
    func addToRecording(motion: Motion) {
        DispatchQueue.main.async {
            let cdMotion: CDMotion = CDMotion(context: self.context)
            cdMotion.timeInterval = motion.timeInterval
            
            let cdAcceleration: CDAcceleration = CDAcceleration(context: self.context)
            cdAcceleration.insertData(from: motion.userAcceleration)
            
            let cdRotationRate: CDRotationRate = CDRotationRate(context: self.context)
            cdRotationRate.insertData(from: motion.rotationRate)
            
            let cdAttitude: CDAttitude = CDAttitude(context: self.context)
            cdAttitude.insertData(from: motion.attitude)
            
            cdMotion.attitude = cdAttitude
            cdMotion.rotationRate = cdRotationRate
            cdMotion.userAcceleration = cdAcceleration
            
            self.runningRecording?.addToMotions(cdMotion)
        }
    }
    
    func addToRecording(hipPosition: SIMD3<Float>) {
        let cdPosition = CDPosition(context: self.context)
        
        cdPosition.timeInterval = Date.now.timeIntervalSinceReferenceDate
        cdPosition.x = hipPosition.x
        cdPosition.y = hipPosition.y
        cdPosition.z = hipPosition.z
        
        self.runningRecording?.addToHipPositions(cdPosition)
    }
}
