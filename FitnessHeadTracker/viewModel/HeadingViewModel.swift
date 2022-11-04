//
//  HeadingViewModel.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 01.11.22.
//

import Combine

class HeadingViewModel: ObservableObject {
    @Published var heading: Heading = Heading.zero
    
    @Published var historicHeadingData: [(acceleration: Heading, timestamp: Double)] = Array(repeating: (Heading.zero, 0.1), count: 30)
    
    private let headingCalculator: any HeadingCalculatorProtocol
    private var headingCancellable: AnyCancellable?
    
    init(headingCalculator: any HeadingCalculatorProtocol) {
        self.headingCalculator = headingCalculator
        self.headingCancellable = headingCalculator._heading.sink(receiveValue: { heading in
            self.heading = heading
        })
    }
    
    func reset() {
        self.headingCalculator.reset()
    }
}
