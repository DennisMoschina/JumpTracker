//
//  JumpHeightCalculator.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 06.07.23.
//

import Foundation
import Accelerate
import OSLog
import os.log


class JumpHeightCalculator {
    private static let logger: Logger = Logger(subsystem: "JumpTracker", category: "JumpHeightCalculator")
    private static let poiLog: OSLog = OSLog(subsystem: "JumpTracker", category: .pointsOfInterest)
    
    private let recording: Recording
    private let filter: Filter?
    
    private var correctionFactor: Double = 1
    
    var calculatedJumpHeight: Double {
        os_signpost(.begin, log: Self.poiLog, name: "calculateJumpHeight")
        defer { os_signpost(.end, log: Self.poiLog, name: "calculateJumpHeight") }
        
        let relativeVerticalAcceleration: [Double] = self.relativeVerticalAccelerations
        
        let verticalPositions: [Double] = relativeVerticalAcceleration.reduce([]) { partialResult, accel in
            var newResult = partialResult
            let posChange: Double = 0.5 * 9.81 * 0.04 * accel
            newResult.append((newResult.last ?? 0) + posChange)
            return newResult
        }
        
        return self.correctionFactor * self.calculateJumpHeight(positions: verticalPositions)
    }
    
    var measuredJumpHeight: Double {
        os_signpost(.begin, log: Self.poiLog, name: "calculateMeasuredJumpHeight")
        defer { os_signpost(.end, log: Self.poiLog, name: "calculateMeasuredJumpHeight") }
        
        guard let verticalHipPositions: [Double] = extractVerticalHipPosition(from: recording) else { return -1 }
        
        return self.calculateJumpHeight(positions: verticalHipPositions)
    }
    
    var verticalAccelerations: [Double] {
        os_signpost(.begin, log: Self.poiLog, name: "calculateVerticalAccel")
        defer { os_signpost(.end, log: Self.poiLog, name: "calculateVerticalAccel") }
        
        return self.extractVerticalAcceleration(from: self.recording)
    }
    var filteredVerticalAccelerations: [Double] {
        os_signpost(.begin, log: Self.poiLog, name: "calculateFilteredVerticalAccel")
        defer { os_signpost(.end, log: Self.poiLog, name: "calculateFilteredVerticalAccel") }
        
        let verticalAccelerations = self.verticalAccelerations
        return self.filter?.filter(verticalAccelerations) ?? verticalAccelerations
    }
    var relativeVerticalAccelerations: [Double] {
        os_signpost(.begin, log: Self.poiLog, name: "calculateRelativeVerticalAccel")
        defer { os_signpost(.end, log: Self.poiLog, name: "calculateRelativeVerticalAccel") }
        
        let filteredVerticalAccelerations = self.filteredVerticalAccelerations
        
        var relativeVerticalAccelerations: [Double] = [filteredVerticalAccelerations.first ?? 0]
        for i in 1..<(recording.motions?.count ?? 0) {
            let newAcceleration = filteredVerticalAccelerations[i] - filteredVerticalAccelerations[i-1]
            relativeVerticalAccelerations.append(newAcceleration)
        }
        return relativeVerticalAccelerations
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
        os_signpost(.begin, log: Self.poiLog, name: "findCorrectionFactor")
        defer { os_signpost(.end, log: Self.poiLog, name: "findCorrectionFactor") }
        
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
        Self.logger.debug("best factor for correction is \(bestFactor) with an average error of \(minError)")
        return bestFactor
    }
    
    private func calculateJumpHeight(positions: [Double]) -> Double {
        os_signpost(.begin, log: Self.poiLog, name: "calculateJumpHeight")
        defer { os_signpost(.end, log: Self.poiLog, name: "calculateJumpHeight") }
        
        guard !positions.isEmpty else { return -1 }
        
        let sortedPositions: [Double] = positions.sorted()
        let ground: Double = sortedPositions[sortedPositions.count / 2]
        let maxHeight = positions.max() ?? ground
        return maxHeight - ground
    }
    
    private func extractVerticalAcceleration(from recording: Recording) -> [Double] {
        os_signpost(.begin, log: Self.poiLog, name: "extractVerticalAccel")
        defer { os_signpost(.end, log: Self.poiLog, name: "extractVerticalAccel") }
        
        guard let motions: NSOrderedSet = recording.motions else {
            fatalError()
        }
        guard motions.count > 0 else { fatalError() }
        
        return motions.map {
            if let f = ($0 as? CDMotion)?.userAcceleration?.z {
                return Double(f)
            } else {
                fatalError()
            }
        }
    }
}
