//
//  File.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation

protocol Filter {
    associatedtype T where T: Numeric
    
    // TODO: use T
    func filter(_ element: Double) -> Double
}
