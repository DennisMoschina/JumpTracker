//
//  MotionCoreDataRecorder.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 07.11.22.
//

import Foundation
import Combine

class MotionCoreDataRecorder {
    var runningRecording: Recording?
    
    var recordOnMonitoringStart: Bool = false
    
    private var motionManager: any MotionManagerProtocol
    private var motionCancellable: AnyCancellable?
    
    private let dataRecorder: DataRecorder
    
    init(motionManager: any MotionManagerProtocol = MotionManager.singleton, dataRecorder: DataRecorder) {
        self.motionManager = motionManager
        self.dataRecorder = dataRecorder
        
        self.motionCancellable = motionManager._motion.sink { motion in
            self.dataRecorder.addToRecording(motion: motion)
        }
    }
}
