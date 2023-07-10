//
//  AutoTimerSettingsViewModel.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 08.07.23.
//

import Foundation
import Combine

class AutoTimerSettingsViewModel: ObservableObject {
    @Published var autoTimerStartOn: Bool {
        didSet {
            self.autoTimerSettings.autoTimerStartOn = self.autoTimerStartOn
        }
    }
    @Published var autoTimerStartTime: TimeInterval {
        didSet {
            self.autoTimerSettings.autoTimerStartTime = self.autoTimerStartTime
        }
    }
    @Published var autoTimerStopOn: Bool {
        didSet {
            self.autoTimerSettings.autoTimerStopOn = self.autoTimerStopOn
        }
    }
    @Published var autoTimerStopTime: TimeInterval {
        didSet {
            self.autoTimerSettings.autoTimerStopTime = self.autoTimerStopTime
        }
    }
    
    private let autoTimerSettings: AutoTimerSettings
    
    private var cancellables: [AnyCancellable] = []
    
    init(autoTimerSettings: AutoTimerSettings = AutoTimerSettings.shared) {
        self.autoTimerSettings = autoTimerSettings
        self.autoTimerStartOn = autoTimerSettings.autoTimerStartOn
        self.autoTimerStartTime = autoTimerSettings.autoTimerStartTime
        self.autoTimerStopOn = autoTimerSettings.autoTimerStopOn
        self.autoTimerStopTime = autoTimerSettings.autoTimerStopTime
        
        self.cancellables.append(contentsOf: [
            self.autoTimerSettings.$autoTimerStartOn.sink(receiveValue: { autoTimerStartOn in
                guard self.autoTimerStartOn != autoTimerStartOn else { return }
                self.autoTimerStartOn = autoTimerStartOn
            }),
            self.autoTimerSettings.$autoTimerStartTime.sink(receiveValue: { autoTimerStartTime in
                guard self.autoTimerStartTime != autoTimerStartTime else { return }
                self.autoTimerStartTime = autoTimerStartTime
            }),
            self.autoTimerSettings.$autoTimerStopOn.sink(receiveValue: { autoTimerStopOn in
                guard self.autoTimerStopOn != autoTimerStopOn else { return }
                self.autoTimerStopOn = autoTimerStopOn
            }),
            self.autoTimerSettings.$autoTimerStopTime.sink(receiveValue: { autoTimerStopTime in
                guard self.autoTimerStopTime != autoTimerStopTime else { return }
                self.autoTimerStopTime = autoTimerStopTime
            })
        ])
    }
}
