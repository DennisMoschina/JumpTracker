//
//  CMExtensions.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 04.11.22.
//

import Foundation
import CoreMotion
import simd
import CoreTransferable


// MARK: - Custom Data types

extension SIMDAcceleration {
    init(_ acceleration: CMAcceleration) {
        self.init(x: acceleration.x, y: acceleration.y, z: acceleration.z)
    }
    
    init(_ a: simd_double3) {
        self.init(x: a.x, y: a.y, z: a.z)
    }
}

extension SIMDRotationRate {
    init(_ rotationRate: CMRotationRate) {
        self.init(x: rotationRate.x, y: rotationRate.y, z: rotationRate.z)
    }
    
    init(_ a: simd_double3) {
        self.init(x: a.x, y: a.y, z: a.z)
    }
}

extension SIMDQuaternion {
    init(_ quaternion: CMQuaternion) {
        self.init(x: quaternion.x, y: quaternion.y, z: quaternion.z, w: quaternion.w)
    }
}

extension SIMDRotationMatrix {
    init(_ rotationMatrix: CMRotationMatrix) {
        self.init(m11: rotationMatrix.m11, m12: rotationMatrix.m12, m13: rotationMatrix.m13,
                  m21: rotationMatrix.m21, m22: rotationMatrix.m22, m23: rotationMatrix.m23,
                  m31: rotationMatrix.m31, m32: rotationMatrix.m32, m33: rotationMatrix.m33)
    }
    
    init(_ r: double3x3) {
        self.init(m11: r.columns.0[0], m12: r.columns.1[0], m13: r.columns.2[0],
                  m21: r.columns.0[1], m22: r.columns.1[1], m23: r.columns.2[1],
                  m31: r.columns.0[2], m32: r.columns.1[2], m33: r.columns.2[2])
    }
}

extension SIMDAttitude {
    init(_ attitude: CMAttitude) {
        self.init(roll: attitude.roll, pitch: attitude.pitch, yaw: attitude.yaw)
    }
    
    init(_ a: simd_double3) {
        self.init(roll: a.x, pitch: a.y, yaw: a.z)
    }
}

// MARK: - CoreData data types

extension Recording: Encodable, Transferable {
    static public var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .json) { recording in
            let encoder = JSONEncoder()
            let encoded: Data? = try? encoder.encode(recording)
            return encoded!
        }
    }
    
    private enum CodingKeys: String, CodingKey {
        case startTime
        case name
        case motions
        case hipPositions
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.startTime, forKey: .startTime)
        try container.encode(self.name, forKey: .name)
        try container.encode((self.motions?.array as? [CDMotion]), forKey: .motions)
        try container.encode((self.hipPositions?.array as? [CDPosition]), forKey: .hipPositions)
    }
}

extension CDPosition: Encodable {
    private enum CodingKeys: String, CodingKey {
        case x
        case y
        case z
        case timeInterval
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.timeInterval, forKey: .timeInterval)
        try container.encode(self.x, forKey: .x)
        try container.encode(self.y, forKey: .y)
        try container.encode(self.z, forKey: .z)
    }
}

extension CDMotion: Encodable {
    private enum CodingKeys: String, CodingKey {
        case attitude
        case rotationRate
        case userAcceleration
        case timeInterval
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.attitude, forKey: .attitude)
        try container.encode(self.rotationRate, forKey: .rotationRate)
        try container.encode(self.userAcceleration, forKey: .userAcceleration)
        try container.encode(self.timeInterval, forKey: .timeInterval)
    }
}

extension CDAttitude: Attitude, Encodable {
    private enum CodingKeys: String, CodingKey {
        case roll
        case pitch
        case yaw
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.roll, forKey: .roll)
        try container.encode(self.pitch, forKey: .pitch)
        try container.encode(self.yaw, forKey: .yaw)
    }
    
    typealias R = SIMDRotationMatrix
    typealias Q = SIMDQuaternion

    var rotationMatrix: SIMDRotationMatrix {
        // TODO: implement
        return SIMDRotationMatrix()
    }
    
    var quaternion: SIMDQuaternion {
        // TODO: implement
        return SIMDQuaternion()
    }
    
    func multiply(byInverseOf attitude: CDAttitude) {
        // TODO: implement
    }
    
    func insertData(from attitude: any Attitude) {
        self.roll = attitude.roll
        self.pitch = attitude.pitch
        self.yaw = attitude.yaw
    }
}

extension CDAcceleration: Acceleration, Encodable {
    private enum CodingKeys: String, CodingKey {
        case x
        case y
        case z
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.x, forKey: .x)
        try container.encode(self.y, forKey: .y)
        try container.encode(self.z, forKey: .z)
    }
    
    func insertData(from acceleration: Acceleration) {
        self.x = acceleration.x
        self.y = acceleration.y
        self.z = acceleration.z
    }
}

extension CDRotationRate: RotationRate, Encodable {
    private enum CodingKeys: String, CodingKey {
        case x
        case y
        case z
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.x, forKey: .x)
        try container.encode(self.y, forKey: .y)
        try container.encode(self.z, forKey: .z)
    }
    
    func insertData(from rotationRate: RotationRate) {
        self.x = rotationRate.x
        self.y = rotationRate.y
        self.z = rotationRate.z
    }
}

// MARK: - Core Motion Data types

extension CMAcceleration: Acceleration {
    init(_ acceleration: Acceleration) {
        self.init(x: acceleration.x, y: acceleration.y, z: acceleration.z)
    }
    
    init(_ a: simd_double3) {
        self.init(x: a.x, y: a.y, z: a.z)
    }
}

extension CMRotationRate: RotationRate {
    init(_ rotationRate: SIMDRotationRate) {
        self.init(x: rotationRate.x, y: rotationRate.y, z: rotationRate.z)
    }
    
    init(_ a: simd_double3) {
        self.init(x: a.x, y: a.y, z: a.z)
    }
}

extension CMQuaternion: Quaternion {
    init(_ quaternion: SIMDQuaternion) {
        self.init(x: quaternion.x, y: quaternion.y, z: quaternion.z, w: quaternion.w)
    }
}

extension CMRotationMatrix: RotationMatrix {
    init(_ rotationMatrix: SIMDRotationMatrix) {
        self.init(m11: rotationMatrix.m11, m12: rotationMatrix.m12, m13: rotationMatrix.m13,
                  m21: rotationMatrix.m21, m22: rotationMatrix.m22, m23: rotationMatrix.m23,
                  m31: rotationMatrix.m31, m32: rotationMatrix.m32, m33: rotationMatrix.m33)
    }
    
    init(_ r: double3x3) {
        self.init(m11: r.columns.0[0], m12: r.columns.1[0], m13: r.columns.2[0],
                  m21: r.columns.0[1], m22: r.columns.1[1], m23: r.columns.2[1],
                  m31: r.columns.0[2], m32: r.columns.1[2], m33: r.columns.2[2])
    }
}

extension CMAttitude: Attitude {
    
}

// MARK: - vector and matrices

extension double3x3 {
    init(_ r: RotationMatrix) {
        self.init(rows: [
            simd_double3(r.m11, r.m12, r.m13),
            simd_double3(r.m21, r.m22, r.m23),
            simd_double3(r.m31, r.m32, r.m33)
        ])
    }
}

extension simd_float3x3 {
    init(_ r: RotationMatrix) {
        self.init(rows: [
            simd_float3(Float(r.m11), Float(r.m12), Float(r.m13)),
            simd_float3(Float(r.m21), Float(r.m22), Float(r.m23)),
            simd_float3(Float(r.m31), Float(r.m32), Float(r.m33))
        ])
    }
}

extension simd_double3 {
    init(_ a: Acceleration) {
        self.init(a.x, a.y, a.z)
    }
    
    init(_ r: RotationRate) {
        self.init(r.x, r.y, r.z)
    }
    
    init(_ a: any Attitude) {
        self.init(a.roll, a.pitch, a.yaw)
    }
}

extension simd_quatf {
    init(_ a: any Attitude) {
        let q: Quaternion = a.quaternion
        self.init(ix: Float(q.x), iy: Float(q.y), iz: Float(q.z), r: Float(q.w))
    }
    
    init(_ q: Quaternion) {
        self.init(ix: Float(q.x), iy: Float(q.y), iz: Float(q.z), r: Float(q.w))
    }
}
