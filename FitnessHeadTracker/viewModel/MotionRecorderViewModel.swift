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
    @Published var isRecording: Bool = false
    
    init(motionRecorder: MotionCoreDataRecorder) {
        self.motionRecorder = motionRecorder
    }
    
    func startRecording() {
        #warning("add check if successfull")
        self.motionRecorder.startRecording()
        self.isRecording = true
    }
    
    func endRecording() {
        self.motionRecorder.endRecording()
        self.isRecording = false
    }
}
