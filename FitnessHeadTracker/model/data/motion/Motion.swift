//
//  Motion.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 13.11.22.
//

import Foundation

protocol Motion {
    associatedtype ACC
    associatedtype RR
    associatedtype ATT
    
    var userAcceleration: ACC? { get set }
    var rotationRate: RR? { get set }
    var attitude: ATT? { get set }
    
    var timeInterval: Double { get set }
}

struct AnyMotion: Motion {
    var userAcceleration: Acceleration?
    var rotationRate: RotationRate?
    var attitude: (any Attitude)?
    
    var timeInterval: Double
}
