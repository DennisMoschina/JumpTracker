//
//  MotionRecorderViewModel.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 17.11.22.
//

import Foundation
import Combine

class MotionRecorderViewModel: ObservableObject {
    private(set) var motionRecorder: MotionCoreDataRecorder
    private(set) var dataRecorder: DataRecorder
    private(set) var hipPositionRecorder: HipPositionRecorder
    
    @Published var isRecording: Bool = false

    init(motionRecorder: MotionCoreDataRecorder, hipPositionRecorder: HipPositionRecorder, dataRecorder: DataRecorder) {
        self.motionRecorder = motionRecorder
        self.dataRecorder = dataRecorder
        self.hipPositionRecorder = hipPositionRecorder
        self.motionRecorder.recordOnMonitoringStart = true
    }
    
    func startRecording() {
        #warning("add check if successfull")
        self.dataRecorder.startRecording()
        self.isRecording = true
    }
    
    func endRecording() {
        self.dataRecorder.stopRecording()
        self.isRecording = false
    }
}
