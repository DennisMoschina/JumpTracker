//
//  EwmaFilter.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation

class EwmaFilter: Filter { 
    private var oldValue: Double = 0
    
    private var alpha: Double
    
    init(alpha: Double) {
        self.alpha = alpha
    }
    
    func filter(_ element: Double) -> Double {
        self.oldValue = self.alpha * element + (1 - self.alpha) * self.oldValue
        return self.oldValue
    }
}
