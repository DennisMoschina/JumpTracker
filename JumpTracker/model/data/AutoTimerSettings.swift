//
//  Settings.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 08.07.23.
//

import Foundation

class AutoTimerSettings {
    static var shared: AutoTimerSettings = AutoTimerSettings()
    
    @Published var autoTimerStartOn: Bool
    @Published var autoTimerStartTime: TimeInterval
    @Published var autoTimerStopOn: Bool
    @Published var autoTimerStopTime: TimeInterval
    
    init(autoTimerStartOn: Bool = false, autoTimerStartTime: TimeInterval = 5, autoTimerStopOn: Bool = false, autoTimerStopTime: TimeInterval = 20) {
        self.autoTimerStartOn = autoTimerStartOn
        self.autoTimerStartTime = autoTimerStartTime
        self.autoTimerStopOn = autoTimerStopOn
        self.autoTimerStopTime = autoTimerStopTime
    }
}
