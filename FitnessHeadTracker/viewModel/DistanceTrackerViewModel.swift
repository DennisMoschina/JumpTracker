//
//  DistanceTrackerViewModel.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 27.10.22.
//

import Combine

class DistanceTrackerViewModel: ObservableObject {
    @Published var distance: Distance = Distance()
    
    private let distanceTracker: any DistanceTrackerProtocol
    private var distanceCancellable: AnyCancellable?
    
    init(distanceTracker: any DistanceTrackerProtocol) {
        self.distanceTracker = distanceTracker
        self.distanceCancellable = distanceTracker._distance.sink(receiveValue: { distance in
            self.distance = distance
        })
    }
    
    func reset() {
        self.distanceTracker.reset()
    }
}
