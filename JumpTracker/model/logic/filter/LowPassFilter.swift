//
//  LowPassFilter.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 05.07.23.
//

import Foundation
import Accelerate

class LowPassFilter: Filter {    
    private let cutoff: Double
    private let sampleRate: Double
    private let order: Int
    
    init(cutoff: Double, sampleRate: Double, order: Int = 5) {
        self.cutoff = cutoff
        self.sampleRate = sampleRate
        self.order = order
    }
    
    func filter(_ element: Double) -> Double {
        fatalError()
    }
    
    func filter(_ dataset: [Double]) -> [Double] {
        fatalError()
    }
}

