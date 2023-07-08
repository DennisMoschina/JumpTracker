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
    var autoTimerSettings: AutoTimerSettings = AutoTimerSettings.shared
    
    @State private var activating: Bool = false
    @State private var showSettings: Bool = false
    
    var body: some View {
        HStack {
            Group {
                Button {
                    if self.viewModel.updating {
                        self.stopRecording()
                    } else {
                        self.activating = true
                        Task {
                            if await self.viewModel.startMonitoring() {
                                if self.autoTimerSettings.autoTimerStartOn {
                                    Timer.scheduledTimer(withTimeInterval: self.autoTimerSettings.autoTimerStartTime, repeats: false) { _ in
                                        toggleTorch(on: true)
                                        DispatchQueue.main.async {
                                            self.recordingViewModel.startRecording()
                                        }
                                    }
                                } else {
                                    self.recordingViewModel.startRecording()
                                }
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
                .onChange(of: self.recordingViewModel.isRecording) { newValue in
                    guard newValue else { return }
                    if self.autoTimerSettings.autoTimerStopOn {
                        Timer.scheduledTimer(withTimeInterval: self.autoTimerSettings.autoTimerStopTime, repeats: false) { _ in
                            DispatchQueue.main.async {
                                self.stopRecording()
                            }
                        }
                    }
                }
            }
            .buttonStyle(.borderedProminent)
            .alert(self.viewModel.reason, isPresented: self.$viewModel.failed) {
                Button("OK") {
                    return
                }
            }
            
            Button {
                self.showSettings.toggle()
            } label: {
                Image(systemName: "gear")
                    .font(.title)
            }
        }
        .sheet(isPresented: self.$showSettings) {
            SettingsView(autoTimerSettingsViewModel: AutoTimerSettingsViewModel(autoTimerSettings: self.autoTimerSettings))
        }
    }
    
    private func stopRecording() {
        self.viewModel.stopMonitoring()
        self.recordingViewModel.endRecording()
        toggleTorch(on: false)
    }
}

struct ManageMonitoringButton_Previews: PreviewProvider {
    static let dataRecorder: DataRecorder = DataRecorder(persistenceController: PersistenceController.preview)

    static var previews: some View {
        ManageMonitoringButton(viewModel: MotionViewModel(motionManager: MotionManager.singleton), recordingViewModel: MotionRecorderViewModel(motionRecorder: MotionCoreDataRecorder(dataRecorder: dataRecorder), hipPositionRecorder: HipPositionRecorder(dataRecorder: dataRecorder), dataRecorder: dataRecorder))
    }
}
