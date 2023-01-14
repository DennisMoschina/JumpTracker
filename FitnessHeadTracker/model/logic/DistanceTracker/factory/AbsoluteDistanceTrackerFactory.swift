//
//  AbsoluteDistanceTrackerFactory.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 13.12.22.
//

import Foundation

protocol AbsoluteDistanceTrackerFactory {
    associatedtype AbsoluteDistanceTracker: AbsoluteDistanceTrackerProtocol
    
    
    /// Create an `AbsoluteDistanceTracker` asynchronosly
    /// - Returns: an instance of the `AbsoluteDistanceTracker`
    func create() async -> Result<AbsoluteDistanceTracker, Error>
}
