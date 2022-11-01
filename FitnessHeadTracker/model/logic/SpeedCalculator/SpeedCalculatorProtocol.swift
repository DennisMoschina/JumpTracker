//
//  SpeedCalculatorProtocol.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 31.10.22.
//

import Foundation
import Combine

protocol SpeedCalculatorProtocol: ObservableObject {
    var speed: Speed { get }
    var _speed: CurrentValueSubject<Speed, Never> { get }
    
    func reset()
}

extension SpeedCalculatorProtocol {
    var speed: Speed {
        get { self._speed.value }
        set { self._speed.value = newValue }
    }
    
    func reset() {
        self.speed = Speed.zero
    }
}

