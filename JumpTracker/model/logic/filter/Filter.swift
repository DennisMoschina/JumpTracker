//
//  File.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation

protocol Filter {
    func filter(_ element: Double) -> Double
    
    func filter(_ dataset: [Double]) -> [Double]
}


extension Filter {
    func filter(_ dataset: [Double]) -> [Double] {
        return dataset.map { self.filter($0) }
    }
}
