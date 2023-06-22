//
//  HipPositionRecorder.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 21.06.23.
//

import Foundation
import Combine
import RealityKit

class HipPositionRecorder {
    var bodySkeleton: BodySkeleton? {
        didSet {
            self.anchorCancellable = bodySkeleton?.$anchorPosition.sink(receiveValue: { position in
                self.dataRecorder.addToRecording(hipPosition: position)
            })
        }
    }
    
    var anchorCancellable: AnyCancellable?
    
    private let dataRecorder: DataRecorder
    
    init(bodySkeleton: BodySkeleton? = nil, dataRecorder: DataRecorder) {
        self.bodySkeleton = bodySkeleton
        self.dataRecorder = dataRecorder
    }
}
