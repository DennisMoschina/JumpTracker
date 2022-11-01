//
//  DistanceTrackerProtocol.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Foundation
import Combine

protocol DistanceTrackerProtocol: ObservableObject {
    var distance: Distance { get }
    var _distance: CurrentValueSubject<Distance, Never> { get }
    
    func reset()
}

extension DistanceTrackerProtocol {
    var distance: Distance {
        get { self._distance.value }
        set { self._distance.value = newValue }
    }
    
    func reset() {
        self.distance = Distance.zero
    }
}
