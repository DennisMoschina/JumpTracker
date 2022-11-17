//
//  MotionRecorderViewModel.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 17.11.22.
//

import Foundation
import Combine

class MotionRecorderViewModel: ObservableObject {
    private var motionRecorder: MotionCoreDataRecorder
    
    init(motionRecorder: MotionCoreDataRecorder) {
        self.motionRecorder = motionRecorder
    }
    
    func startRecording() {
        self.motionRecorder.startRecording()
    }
    
    func endRecording() {
        self.motionRecorder.endRecording()
    }
}
