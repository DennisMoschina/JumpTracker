//
//  ManageMonitoringButton.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 02.12.22.
//

import SwiftUI

struct ManageMonitoringButton: View {
    @ObservedObject var viewModel: MotionViewModel
    @ObservedObject var recordingViewModel: MotionRecorderViewModel
    
    var body: some View {
        Group {
            if self.viewModel.updating {
                Button {
                    self.viewModel.stopMonitoring()
                    self.recordingViewModel.endRecording()
                } label: {
                    Text("Stop Motion Monitoring")
                        .padding()
                }
                .tint(.red)
            } else {
                Button {
                    self.viewModel.startMonitoring()
                    self.recordingViewModel.startRecording()
                } label: {
                    Text("Start Motion Monitoring")
                        .padding()
                }
            }
        }
        .buttonStyle(.borderedProminent)
        .alert(self.viewModel.reason, isPresented: self.$viewModel.failed) {
            Button("OK") {
                return
            }
        }
    }
}

struct ManageMonitoringButton_Previews: PreviewProvider {
    static let dataRecorder: DataRecorder = DataRecorder(persistenceController: PersistenceController.preview)

    static var previews: some View {
        ManageMonitoringButton(viewModel: MotionViewModel(motionManager: MotionManager.singleton), recordingViewModel: MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder(dataRecorder: dataRecorder), hipPositionRecorder: HipPositionRecorder(dataRecorder: dataRecorder), dataRecorder: dataRecorder))
    }
}
