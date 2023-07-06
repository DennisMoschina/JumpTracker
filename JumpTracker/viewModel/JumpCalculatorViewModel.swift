//
//  JumpCalculatorViewModel.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 06.07.23.
//

import Foundation

class JumpCalculatorViewModel: ObservableObject {
    @Published var calculatedJumpHeight: Double = 0
    @Published var measuredJumpHeight: Double = 0
    
    private let jumpCalculator: JumpHeightCalculator
    
    init(recording: Recording) {
        self.jumpCalculator = JumpHeightCalculator(recording: recording)
        self.calculate()
    }
    
    func calculate() {
        self.calculatedJumpHeight = self.jumpCalculator.calculatedJumpHeight
        self.measuredJumpHeight = self.jumpCalculator.measuredJumpHeight
    }
}
