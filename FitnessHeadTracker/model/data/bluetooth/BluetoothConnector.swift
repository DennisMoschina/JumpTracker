//
//  BluetoothConnector.swift
//  Smart Rope
//
//  Created by Dennis Moschina on 28.12.21.
//

import Foundation
import CoreBluetooth
import Combine

/**
 * This class describes a Connector for Bluetooth Devices.
 *
 * - Author: Dennis Moschina
 * - Version: 1.0
 */
class BluetoothConnector: NSObject, Connector {
    var connectedDevices: [BluetoothDevice]  {
        get { self._connectedDevices.value }
        set { self._connectedDevices.value = newValue }
    }
    var _connectedDevices: CurrentValueSubject<[BluetoothDevice], Never> = CurrentValueSubject([])
    
    private let bleManager: BLEManagerProtocol
    
    private var waitingForStateUpdate: [CBPeripheral : BluetoothDevice] = [:]
    
    init(manager: BLEManagerProtocol = BLEManager.Singleton) {
        self.bleManager = manager
        super.init()
        
        self.connectedDevices = self.bleManager.connectedDevices
    }
    
    deinit {
        self.removeConnectCallbacks()
        self.removeDisconnectCallbacks()
    }
    
    /**
     * Connect to a device with some options on how to connect.
     * - parameters:
     *      - device: the device to connect to
     *      - options: the options on how to connect
     */
    func connect(to device: BluetoothDevice, with options: BluetoothConnectionOptions) {
        self.setConnectCallbacks()
        
        if device.state != .connected {
            device.state = .connecting
            self.waitingForStateUpdate[device.peripheral] = device
            self.bleManager.connect(to: device, with: options)
        }
    }
    
    /**
     * Connect to a device.
     * - parameter device: the device to connect to
     */
    func connect(to device: BluetoothDevice) {
        self.connect(to: device, with: BluetoothConnectionOptions(options: nil))
    }
    
    /**
     * Disconnect from a device.
     * - parameter device: the device to disconnect from
     */
    func disconnect(from device: BluetoothDevice) {
        self.setDisconnectCallbacks()
        
        device.state = .disconnecting
        self.waitingForStateUpdate[device.peripheral] = device
        self.bleManager.disconnect(from: device)
    }
    
    //MARK: - Helper Methods

    private func updateState(for peripheral: CBPeripheral) {
        self.waitingForStateUpdate[peripheral]?.state = ConnectionState(rawValue: peripheral.state.rawValue)!
        self.waitingForStateUpdate.removeValue(forKey: peripheral)
    }
    
    private func setConnectCallbacks() {
        self.bleManager.onConnect(self) { _ in
            self.connectedDevices = self.bleManager.connectedDevices
        }
    }
    
    private func removeConnectCallbacks() {
        self.bleManager.removeOnConnect(self)
        self.bleManager.removeOnFailedConnect(self)
    }
    
    private func setDisconnectCallbacks() {
    }
    
    private func removeDisconnectCallbacks() {
        self.bleManager.removeOnDisconnect(self)
    }
}
