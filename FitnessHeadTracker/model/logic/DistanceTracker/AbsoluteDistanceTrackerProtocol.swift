//
//  AbsoluteDistanceTrackerProtocol.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 12.12.22.
//

import Foundation
import Combine

protocol AbsoluteDistanceTrackerProtocol: ObservableObject {
    var distance: AbsoluteDistance { get }
    var _distance: CurrentValueSubject<AbsoluteDistance, Never> { get }
    
    func start()
    func stop()
    
    func reset()
}

extension AbsoluteDistanceTrackerProtocol {
    var distance: AbsoluteDistance {
        get { self._distance.value }
        set { self._distance.value = newValue }
    }
    
    func reset() {
        self.distance = AbsoluteDistance.zero
    }
}
