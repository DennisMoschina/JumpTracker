//
//  Device.swift
//  Smart Rope
//
//  Created by Dennis Moschina on 28.12.21.
//

import Combine

/**
 * This interface describes a Device.
 *
 * - Author: Dennis Moschina
 *  - Version: 1.0
 */
protocol Device {
    /// The name of the device.
    var name: String? { get set }
    var _name: CurrentValueSubject<String?, Never> { get }
    
    /// The state of the connection to the device.
    var state: ConnectionState { get set }
    var _state: CurrentValueSubject<ConnectionState, Never> { get }
    
    var rssi: Double { get set }
    var _rssi: CurrentValueSubject<Double, Never> { get }
    
    func updateRSSI()
    
    func isEqual(to device: Device) -> Bool
}

extension Device {
    var name: String? {
        get { self._name.value }
        set { self._name.value = newValue }
    }
    
    var state: ConnectionState {
        get { self._state.value }
        set { self._state.value = newValue }
    }
    
    var rssi: Double {
        get { self._rssi.value }
        set { self._rssi.value = newValue }
    }
}
