//
//  DeviceMock.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 15.12.22.
//

import Foundation
import Combine

class DeviceMock: Device {
    private static var idCounter: Int = 0
    
    var _name: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    var _state: CurrentValueSubject<ConnectionState, Never> = CurrentValueSubject(.disconnected)
    var _rssi: CurrentValueSubject<Double, Never> = CurrentValueSubject(0)
    
    private var id: Int
    
    init(name: String?, state: ConnectionState) {
        self.id = Self.idCounter
        Self.idCounter += 1
        
        self._name = CurrentValueSubject(name)
        self._state = CurrentValueSubject(state)
    }
    
    func updateRSSI() {
        self._rssi.value += 10
    }
    
    func isEqual(to device: Device) -> Bool {
        if device is DeviceMock, let mockDevice: DeviceMock = device as? DeviceMock {
            return mockDevice.id == self.id
        }
        return false
    }
}
