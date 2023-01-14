//
//  AbsoluteDistanceTrackerViewModel.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 12.12.22.
//

import Foundation
import Combine

class AbsoluteDistanceTrackerViewModel: ObservableObject {
    @Published var distance: AbsoluteDistance = AbsoluteDistance.zero
    @Published var ready: Bool = false
    @Published var failed: Bool = false
    
    private var tracker: (any AbsoluteDistanceTrackerProtocol)? {
        didSet {
            if let tracker {
                self.distanceCancellable = tracker._distance.receive(on: DispatchQueue.main).sink(receiveValue: { distance in
                    self.distance = distance
                })
                DispatchQueue.main.async {
                    self.ready = true
                }
            }
        }
    }
    private var distanceCancellable: AnyCancellable?

    init(trackerFactory: some AbsoluteDistanceTrackerFactory) {
        Task {
            let result = await trackerFactory.create()
            switch result {
            case .success(_):
                do {
                    self.tracker = try result.get()
                } catch {
                    self.failed = true
                }
            case .failure(_):
                self.failed = true
            }
        }
    }
    
    func start() {
        self.tracker?.start()
    }
    
    func stop() {
        self.tracker?.stop()
    }
}
