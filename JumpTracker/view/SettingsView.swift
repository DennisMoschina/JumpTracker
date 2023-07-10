//
//  SettingsView.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 08.07.23.
//

import SwiftUI

enum AutoTimerStartTimeSteps: TimeInterval, CaseIterable, Identifiable {
    var id: TimeInterval { self.rawValue }
    
    case oneSecond = 1
    case twoSeconds = 2
    case threeSeconds = 3
    case fiveSeconds = 5
    case tenSeconds = 10
}

enum AutoTimerStopTimeSteps: TimeInterval, CaseIterable, Identifiable {
    var id: TimeInterval { self.rawValue }
    
    case fiveSeconds = 5
    case tenSeconds = 10
    case twentySeconds = 20
    case oneMinute = 60
}

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var autoTimerSettingsViewModel: AutoTimerSettingsViewModel
    @ObservedObject var jumpAnalysisViewModel: JumpAnalysisSettingsViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Auto-Timer") {
                    Toggle(isOn: self.$autoTimerSettingsViewModel.autoTimerStartOn) {
                        Text("Auto-Timer Start")
                    }
                    if self.autoTimerSettingsViewModel.autoTimerStartOn {
                        Picker("Stop Time", selection: self.$autoTimerSettingsViewModel.autoTimerStartTime) {
                            ForEach(AutoTimerStartTimeSteps.allCases) { interval in
                                Text("\(interval.rawValue, specifier: "%.0f") s")
                            }
                        }
                    }
                    
                    Toggle(isOn: self.$autoTimerSettingsViewModel.autoTimerStopOn) {
                        Text("Auto-Timer Stop")
                    }
                    if self.autoTimerSettingsViewModel.autoTimerStopOn {
                        Picker("Stop Time", selection: self.$autoTimerSettingsViewModel.autoTimerStopTime) {
                            ForEach(AutoTimerStopTimeSteps.allCases) { interval in
                                Text("\(interval.rawValue, specifier: "%.0f") s")
                            }
                        }
                    }
                }
                
                Section("Jump Analysis") {
                    Toggle(isOn: self.$jumpAnalysisViewModel.showAnalysisAfterRecording) {
                        Text("Show Analysis after recording")
                    }
                    if self.jumpAnalysisViewModel.showAnalysisAfterRecording {
                        Toggle(isOn: self.$jumpAnalysisViewModel.showTrainedAnalysis) {
                            Text("Use other recordings to improve calculation")
                        }
                        Toggle(isOn: self.$jumpAnalysisViewModel.showMeasured) {
                            Text("Show measured jump height")
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                Button("Done") {
                    self.dismiss()
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(autoTimerSettingsViewModel: AutoTimerSettingsViewModel(), jumpAnalysisViewModel: JumpAnalysisSettingsViewModel())
    }
}
