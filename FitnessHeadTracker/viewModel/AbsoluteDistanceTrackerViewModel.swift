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
    
    private var trackerFactory: any AbsoluteDistanceTrackerFactory
    
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
        self.trackerFactory = trackerFactory
        self.createTracker(factory: trackerFactory)
    }
    
    public func start() {
        if self.tracker == nil {
            self.createTracker(factory: self.trackerFactory)
        }
        self.tracker?.start()
    }
    
    public func stop() {
        self.tracker?.stop()
    }
    
    private func createTracker(factory: some AbsoluteDistanceTrackerFactory) {
        Task {
            self.failed = false
            let result = await factory.create()
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
}
