//
//  SpeedCalculatorProtocol.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 31.10.22.
//

import Foundation
import Combine

protocol SpeedCalculatorProtocol: ObservableObject {
    var speed: any Speed { get }
    var _speed: CurrentValueSubject<any Speed, Never> { get }
    
    func reset()
}

extension SpeedCalculatorProtocol {
    var speed: any Speed {
        get { self._speed.value }
        set { self._speed.value = newValue }
    }
    
    func reset() {
        self.speed = SIMDSpeed()
    }
}

