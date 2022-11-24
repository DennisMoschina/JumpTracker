//
//  RecordingViewModel.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 18.11.22.
//

import Foundation
import Combine
import CoreData

class RecordingViewModel: ObservableObject {
    private let persistenceController: PersistenceController
    private let context: NSManagedObjectContext
    
    var recordingName: String {
        get { return self.recording.name ?? self.recording.startTime?.description ?? "N/A" }
        set { self.recording.name = newValue }
    }
    
    var recording: Recording {
        didSet {
            self.save()
        }
    }
    
    var recordingDuration: Double {
        self.recording.motions?.reduce(0, { partialResult, motion in
            partialResult + (motion as! CDMotion).timeInterval
        }) ?? 0
    }
    
    let motionArray: [CDMotion]
    let accelerationChartData: [(axis: String, data: [(timestamp: Double, data: Double)])]
    
    init(recording: Recording,
         persistenceController: PersistenceController = PersistenceController.shared,
         context: NSManagedObjectContext? = nil) {
        self.recording = recording
        
        self.persistenceController = persistenceController
        
        self.context = context ?? self.persistenceController.container.newBackgroundContext()
        
        self.motionArray = self.recording.motions?.array as! [CDMotion]
        
        self.accelerationChartData = [
            (
                axis: "X",
                data: self.motionArray.reduce([], { partialResult, motion in
                    var newResult: [(timestamp: Double, data: Double)] = partialResult
                    let lastTimestamp: Double = newResult.last?.timestamp ?? 0
                    newResult.append((timestamp: motion.timeInterval + lastTimestamp, data: motion.userAcceleration?.x ?? 0))
                    
                    return newResult
                })
            ),
            (
                axis: "Y",
                data: self.motionArray.reduce([], { partialResult, motion in
                    var newResult: [(timestamp: Double, data: Double)] = partialResult
                    let lastTimestamp: Double = newResult.last?.timestamp ?? 0
                    newResult.append((timestamp: motion.timeInterval + lastTimestamp, data: motion.userAcceleration?.y ?? 0))
                    
                    return newResult
                })
            ),
            (
                axis: "Z",
                data: self.motionArray.reduce([], { partialResult, motion in
                    var newResult: [(timestamp: Double, data: Double)] = partialResult
                    let lastTimestamp: Double = newResult.last?.timestamp ?? 0
                    newResult.append((timestamp: motion.timeInterval + lastTimestamp, data: motion.userAcceleration?.z ?? 0))
                    
                    return newResult
                })
            )
        ]
        
    }
    
    func save() {
        self.persistenceController.save()
    }
}
