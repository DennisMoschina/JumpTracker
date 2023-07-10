//
//  JumpHeightCalculator.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 06.07.23.
//

import Foundation
import Accelerate


class JumpHeightCalculator {
    private let recording: Recording
    private let filter: Filter?
    
    private var correctionFactor: Double = 1
    
    var calculatedJumpHeight: Double {
        guard let motions: NSOrderedSet = self.recording.motions else {
            return -1
        }
        let accelerations: [Acceleration] = motions.compactMap { motion in
            (motion as? CDMotion)?.userAcceleration
        }
        var verticalAccelerations: [Double] = accelerations.map { $0.z }
        if let filter = self.filter {
            verticalAccelerations = filter.filter(verticalAccelerations)
        }
        var relativeVerticalAcceleration: [Double] = [verticalAccelerations[0]]
        for i in 1..<verticalAccelerations.count {
            let newAcceleration = verticalAccelerations[i] - verticalAccelerations[i-1]
            relativeVerticalAcceleration.append(newAcceleration)
        }
        
        let verticalPositions: [Double] = relativeVerticalAcceleration.reduce([]) { partialResult, accel in
            var newResult = partialResult
            let posChange: Double = 0.5 * 9.81 * 0.04 * accel
            newResult.append((newResult.last ?? 0) + posChange)
            return newResult
        }
        
        return self.correctionFactor * self.calculateJumpHeight(positions: verticalPositions)
    }
    
    var measuredJumpHeight: Double {
        guard let hipPositions: NSOrderedSet = self.recording.hipPositions else {
            return -1
        }
        guard hipPositions.count > 0 else { return -1 }
        
        let verticalHipPositions: [Double] = hipPositions.compactMap {
            if let f = ($0 as? CDPosition)?.y {
                return Double(f)
            } else { return nil }
        }
        
        return self.calculateJumpHeight(positions: verticalHipPositions)
    }
    
    init(recording: Recording, filter: Filter? = nil) {
        self.recording = recording
        self.filter = filter
    }
    
    func train(with recordings: [Recording]) {
        var difference: [(measured: Double, calculated: Double)] = []
        for recording in recordings {
            let calculator = JumpHeightCalculator(recording: recording, filter: self.filter)
            difference.append((measured: calculator.measuredJumpHeight, calculated: calculator.calculatedJumpHeight))
        }
        
        self.correctionFactor = self.findFactor(measuredHeights: difference.map { $0.measured }, calculatedHeights: difference.map { $0.calculated })
    }
    
    private func findFactor(measuredHeights: [Double], calculatedHeights: [Double]) -> Double {
        let minFactor = 0.5
        let maxFactor = 2.0
        let stepSize = 0.001

        // Initialize variables to store best factor and minimum error
        var bestFactor = 0.0
        var minError = Double.infinity

        // Perform grid search
        for factor in stride(from: minFactor, to: maxFactor, by: stepSize) {
            var scaledCalculatedHeights = [Double](repeating: 0.0, count: calculatedHeights.count)
            vDSP_vsmulD(calculatedHeights, 1, [factor], &scaledCalculatedHeights, 1, vDSP_Length(calculatedHeights.count))
            
            var errors: [Double] = .init(repeating: 0, count: calculatedHeights.count)
            var error: Double = 0
            vDSP_vsubD(measuredHeights, 1, scaledCalculatedHeights, 1, &errors, 1, vDSP_Length(measuredHeights.count))
            vDSP_meamgvD(&errors, 1, &error, vDSP_Length(measuredHeights.count))
            
            // Update best factor and minimum error if a better result is found
            if error < minError {
                bestFactor = factor
                minError = error
            }
        }
        return bestFactor
    }
    
    private func calculateJumpHeight(positions: [Double]) -> Double {
        guard !positions.isEmpty else { return -1 }
        
        let sortedPositions: [Double] = positions.sorted()
        let ground: Double = sortedPositions[sortedPositions.count / 2]
        let maxHeight = positions.max() ?? ground
        return maxHeight - ground
    }
}
