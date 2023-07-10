//
//  JumpHeightCalculator.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 06.07.23.
//

import Foundation


class JumpHeightCalculator {
    private let recording: Recording
    private let filter: Filter?
    
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
        
        return self.calculateJumpHeight(positions: verticalPositions)
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
    
    private func calculateJumpHeight(positions: [Double]) -> Double {
        guard !positions.isEmpty else { return -1 }
        
        let sortedPositions: [Double] = positions.sorted()
        let ground: Double = sortedPositions[sortedPositions.count / 2]
        let maxHeight = positions.max() ?? ground
        return maxHeight - ground
    }
}
