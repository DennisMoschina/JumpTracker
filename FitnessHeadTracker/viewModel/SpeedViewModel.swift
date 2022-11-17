//
//  SpeedViewModel.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 31.10.22.
//

import Combine
import Foundation

class SpeedViewModel: ObservableObject {
    @Published var speed: any Speed = SIMDSpeed.zero
    
    private let speedCalculator: any SpeedCalculatorProtocol
    private var speedCancellable: AnyCancellable?
    
    init(speedCalculator: any SpeedCalculatorProtocol) {
        self.speedCalculator = speedCalculator
        self.speedCancellable = speedCalculator._speed.receive(on: DispatchQueue.main).sink(receiveValue: { speed in
            self.speed = speed
        })
    }
    
    func reset() {
        self.speedCalculator.reset()
    }
}
