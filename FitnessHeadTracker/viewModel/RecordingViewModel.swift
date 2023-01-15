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
    let accelerationChartData: Chart3dDataOverTime
    let rotationRateChartData: Chart3dDataOverTime
    let attitudeChartData: Chart3dDataOverTime
    
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
                data: self.motionArray.compactMap({ $0.userAcceleration }).map { (acceleration: Acceleration) in
                    acceleration.x
                }
            ),
            (
                axis: "Y",
                data: self.motionArray.compactMap({ $0.userAcceleration }).map { (acceleration: Acceleration) in
                    acceleration.y
                }
            ),
            (
                axis: "Z",
                data: self.motionArray.compactMap({ $0.userAcceleration }).map { (acceleration: Acceleration) in
                    acceleration.z
                }
            ),
        ]
        
        self.rotationRateChartData = [
            (
                axis: "X",
                data: self.motionArray.compactMap({ $0.rotationRate }).map { (rotationRate: RotationRate) in
                    rotationRate.x
                }
            ),
            (
                axis: "Y",
                data: self.motionArray.compactMap({ $0.rotationRate }).map { (rotationRate: RotationRate) in
                    rotationRate.y
                }
            ),
            (
                axis: "Z",
                data: self.motionArray.compactMap({ $0.rotationRate }).map { (rotationRate: RotationRate) in
                    rotationRate.z
                }
            ),
        ]
        
        self.attitudeChartData = [
            (
                axis: "roll",
                data: self.motionArray.compactMap({ $0.attitude }).map { (attitude: Attitude) in
                    attitude.roll
                }
            ),
            (
                axis: "pitch",
                data: self.motionArray.compactMap({ $0.attitude }).map { (attitude: Attitude) in
                    attitude.pitch
                }
            ),
            (
                axis: "yaw",
                data: self.motionArray.compactMap({ $0.attitude }).map { (attitude: Attitude) in
                    attitude.yaw
                }
            ),
        ]
    }
    
    func save() {
        self.persistenceController.save()
    }
}
