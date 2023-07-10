//
//  JumpAnalysisSettings.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 10.07.23.
//

import Foundation

class JumpAnalysisSettings {
    static let shared: JumpAnalysisSettings = JumpAnalysisSettings()
    static let all: JumpAnalysisSettings = JumpAnalysisSettings()
    
    @Published var showAnalysisAfterRecording: Bool = false
    @Published var showTrainedAnalysis: Bool = true
    @Published var showMeasured: Bool = true
}
