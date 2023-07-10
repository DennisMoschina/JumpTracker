//
//  JumpAnalysisSettingsViewModel.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 10.07.23.
//

import Foundation
import Combine

class JumpAnalysisSettingsViewModel: ObservableObject {
    @Published var showAnalysisAfterRecording: Bool {
        didSet {
            self.jumpAnalysisSettings.showAnalysisAfterRecording = self.showAnalysisAfterRecording
        }
    }
    @Published var showTrainedAnalysis: Bool {
        didSet {
            self.jumpAnalysisSettings.showTrainedAnalysis = self.showTrainedAnalysis
        }
    }
    @Published var showMeasured: Bool {
        didSet {
            self.jumpAnalysisSettings.showMeasured = self.showMeasured
        }
    }
    
    private let jumpAnalysisSettings: JumpAnalysisSettings
    
    private var cancellables: [AnyCancellable] = []
    
    init(jumpAnalysisSettings: JumpAnalysisSettings = JumpAnalysisSettings.shared) {
        self.showTrainedAnalysis = jumpAnalysisSettings.showTrainedAnalysis
        self.showAnalysisAfterRecording = jumpAnalysisSettings.showAnalysisAfterRecording
        self.showMeasured = jumpAnalysisSettings.showMeasured
        self.jumpAnalysisSettings = jumpAnalysisSettings
        
        self.cancellables.append(contentsOf: [
            self.jumpAnalysisSettings.$showTrainedAnalysis.sink(receiveValue: { showTrainedAnalysis in
                guard self.showTrainedAnalysis != showTrainedAnalysis else { return }
                self.showTrainedAnalysis = showTrainedAnalysis
            }),
            self.jumpAnalysisSettings.$showAnalysisAfterRecording.sink(receiveValue: { showAnalysisAfterRecording in
                guard self.showAnalysisAfterRecording != showAnalysisAfterRecording else { return }
                self.showAnalysisAfterRecording = showAnalysisAfterRecording
            }),
            self.jumpAnalysisSettings.$showMeasured.sink(receiveValue: { showMeasured in
                guard self.showMeasured != showMeasured else { return }
                self.showMeasured = showMeasured
            })
        ])
    }
}
