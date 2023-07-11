//
//  JumpCalculatorViewModel.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 06.07.23.
//

import Foundation
import CoreData

class JumpCalculatorViewModel: ObservableObject {
    @Published var calculatedJumpHeight: Double = 0
    @Published var measuredJumpHeight: Double = 0
    
    @Published var verticalHipPositions: [Double]
    
    @Published var verticalAcceleration: [Double]
    @Published var filteredVerticalAcceleration: [Double]
    @Published var relativeVerticalAcceleration: [Double]
    

    private let jumpCalculator: JumpHeightCalculator
    
    convenience init(recording: Recording, trained: Bool, context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        if trained {
            let fetchRequest = Recording.fetchRequest()
            let recordings = (try? context.fetch(fetchRequest)) ?? []
            self.init(recording: recording, trainedOn: recordings)
        } else {
            self.init(recording: recording)
        }
    }
    
    init(recording: Recording, trainedOn recordings: [Recording] = []) {
        let jumpCalculator = JumpHeightCalculator(recording: recording, filter: LowPassFilter(a: [1, -3.9926486, 6.45953643, -5.28227516 , 2.18014463, -0.36291277], b: [5.76413529e-05, 2.88206765e-04, 5.76413529e-04, 5.76413529e-04, 2.88206765e-04, 5.76413529e-05]))
        self.jumpCalculator = jumpCalculator
        self.verticalHipPositions = extractVerticalHipPosition(from: recording) ?? []
        
        self.verticalAcceleration = jumpCalculator.verticalAccelerations
        self.filteredVerticalAcceleration = jumpCalculator.filteredVerticalAccelerations
        self.relativeVerticalAcceleration = jumpCalculator.relativeVerticalAccelerations
        
        if !recordings.isEmpty {
            self.jumpCalculator.train(with: recordings)
        }
        self.calculate()
    }
    
    func calculate() {
        self.calculatedJumpHeight = self.jumpCalculator.calculatedJumpHeight
        self.measuredJumpHeight = self.jumpCalculator.measuredJumpHeight
    }
}
