//
//  BluetoothDevice.swift
//  Smart Rope
//
//  Created by Dennis Moschina on 28.12.21.
//

import Combine
import CoreBluetooth

/**
 * This struct describes a Bluetooth Device.
 *
 * - Author: Dennis Moschina
 * - Version: 1.0
 */
class BluetoothDevice: NSObject, Device, CBPeripheralDelegate {
    
    let peripheral: CBPeripheral
    
    var name: String? {
        get { self._name.value }
        set { self._name.value = newValue }
    }
    var _name: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    
    var state: ConnectionState {
        get { self._state.value }
        set { self._state.value = newValue }
    }
    var _state: CurrentValueSubject<ConnectionState, Never> = CurrentValueSubject(.disconnected)
    
    var rssi: Double {
        get { self._rssi.value }
        set { self._rssi.value = newValue }
    }
    var _rssi: CurrentValueSubject<Double, Never> = CurrentValueSubject(-1)
    
    init(peripheral: CBPeripheral) {
        self.peripheral = peripheral
        super.init()
        self.name = self.peripheral.name
        self.state = ConnectionState(rawValue: self.peripheral.state.rawValue)!
        self.peripheral.delegate = self
    }
    
    func updateRSSI() {
        self.peripheral.readRSSI()
    }
    
    func isEqual(to device: Device) -> Bool {
        if device is BluetoothDevice, let bluetoothDevice: BluetoothDevice = device as? BluetoothDevice {
            return self == bluetoothDevice
        }
        return false
    }
    
    // MARK: - Delegate Methods
    
    func peripheralDidUpdateName(_ peripheral: CBPeripheral) {
        self.name = peripheral.name
    }
    
    func peripheral(_ peripheral: CBPeripheral, didReadRSSI RSSI: NSNumber, error: Error?) {
        if let error {
            print("type: \(type(of: error)), error: \(error)")
            print("description: \(error.localizedDescription)")
        }
        self.rssi = Double(truncating: RSSI)
        print("rssi: \(self.rssi)")
    }
}
