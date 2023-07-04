//
//  Attitude.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 04.11.22.
//

import Foundation

protocol Attitude {
    associatedtype R: RotationMatrix
    associatedtype Q: Quaternion
    
    var roll: Double { get }
    var pitch: Double { get }
    var yaw: Double { get }
    
    var rotationMatrix: R { get }
    
    var quaternion: Q { get }
    
    func multiply(byInverseOf attitude: Self)
}
