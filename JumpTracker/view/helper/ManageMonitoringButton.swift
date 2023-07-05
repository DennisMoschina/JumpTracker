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
    
    @State private var activating: Bool = false
    
    var body: some View {
        Group {
            Button {
                if self.viewModel.updating {
                    self.viewModel.stopMonitoring()
                    self.recordingViewModel.endRecording()
                } else {
                    self.activating = true
                    Task {
                        if await self.viewModel.startMonitoring() {
                            self.recordingViewModel.startRecording()
                        }
                        DispatchQueue.main.async { self.activating = false }
                    }
                }
            } label: {
                ZStack {
                    if self.activating {
                        ProgressView()
                    }
                    Text(self.viewModel.updating ? "Stop Motion Monitoring" : "Start Motion Monitoring")
                        .padding()
                }
            }
            .tint(self.viewModel.updating ? .red : .accentColor)
            .disabled(self.activating)
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
