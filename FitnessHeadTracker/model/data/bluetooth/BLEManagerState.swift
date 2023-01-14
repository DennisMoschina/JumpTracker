//
//  BLEManagerState.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 16.12.22.
//

import Foundation
import CoreBluetooth

enum BLEManagerState: Int {
    case poweredOff
    case poweredOn
    case resetting
    case unauthorized
    case unknown
    case unsupported
}

extension BLEManagerState {
    static func fromCBState(state: CBManagerState) -> Self {
        switch state {
        case .unknown:
            return .unknown
        case .resetting:
            return .resetting
        case .unsupported:
            return .unsupported
        case .unauthorized:
            return .unauthorized
        case .poweredOff:
            return .poweredOff
        case .poweredOn:
            return .poweredOn
        @unknown default:
            fatalError("unknown Bluetooth state")
        }
    }
}
