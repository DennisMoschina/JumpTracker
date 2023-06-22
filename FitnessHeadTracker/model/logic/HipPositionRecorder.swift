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
            self.jointsCancellable = bodySkeleton?.$joints.sink(receiveValue: { joints in
                self.updatedJoints(joints)
            })
        }
    }
    
    var jointsCancellable: AnyCancellable?
    
    private let dataRecorder: DataRecorder
    
    init(bodySkeleton: BodySkeleton? = nil, dataRecorder: DataRecorder) {
        self.bodySkeleton = bodySkeleton
        self.dataRecorder = dataRecorder
    }
    
    private func updatedJoints(_ joints: [String : Entity]) {
        if let hipJoint = joints["hip_joint"] {
            self.dataRecorder.addToRecording(hipPosition: hipJoint.position)
        }
    }
}
