//
//  LowPassFilter.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 05.07.23.
//

import Foundation
import Accelerate

class LowPassFilter: Filter {    
    private let a: [Double]
    private let b: [Double]
    
    init(a: [Double], b: [Double]) {
        self.a = a
        self.b = b
    }
    
    func filter(_ element: Double) -> Double {
        fatalError()
    }
    
    func filter(_ dataset: [Double]) -> [Double] {
        self.filter_direct_ii(b: self.b, a: self.a, y: dataset)
    }
    
    private func filter_direct_ii(b: [Double], a: [Double], y: [Double]) -> [Double] {
        var y_filt = [Double](repeating: 0.0, count: y.count)
        let N = b.count
        var buffer = [Double](repeating: 0.0, count: N)
        
        for n in 0..<y.count {
            buffer[0] = a[0] * y[n]
            
            for k in 1..<N {
                buffer[0] -= a[k] * buffer[k]
                y_filt[n] += b[k] * buffer[k]
            }
            
            y_filt[n] += b[0] * buffer[0]
            buffer = [buffer[0]] + buffer.dropLast()
        }
        
        return y_filt
    }
}

