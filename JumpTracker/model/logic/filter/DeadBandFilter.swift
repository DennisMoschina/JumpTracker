//
//  DeadBandFilter.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation

class DeadBandFilter: Filter {
    private let deadBand: Double
    
    init(deadBand: Double) {
        self.deadBand = deadBand
    }
    
    func filter(_ element: Double) -> Double {
        return abs(element) < deadBand ? 0 : element
    }
}
