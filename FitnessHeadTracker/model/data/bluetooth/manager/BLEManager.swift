//
//  BLEManager.swift
//  Smart Rope
//
//  Created by Dennis Moschina on 02.02.22.
//

import Foundation
import CoreBluetooth

class BLEManager: NSObject, BLEManagerProtocol, CBCentralManagerDelegate {
    
    static var Singleton: BLEManagerProtocol = BLEManager()
    
    public var connectedDevices: [BluetoothDevice] = []
    public var availableDevices: [BluetoothDevice] = []
    public var isScanning: Bool { self.manager.isScanning }
    public var state: BLEManagerState {
        BLEManagerState.fromCBState(state: self.manager.state)
    }
    
    private var manager: CBCentralManager!
    
    #warning("TODO: remove closures when objects are no longer needed")
    private var onConnect: [NSObject : (BluetoothDevice) -> ()] = [:]
    private var onFailedConnect: [NSObject : (BluetoothDevice) -> ()] = [:]
    private var onDisconnect: [NSObject : (BluetoothDevice) -> ()] = [:]
    private var onDiscover: [NSObject : (BluetoothDevice) -> ()] = [:]

    private var onStateUpdate: [NSObject : (BLEManagerProtocol) -> ()] = [:]
    
    private override init() {
        super.init()
        self.manager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func scan(with options: BluetoothScanningOptions?) throws {
        switch self.manager.state {
        case .unknown, .resetting, .poweredOff:
            throw ForbiddenActionError.wrongState(reason: "Unavailable", description: "Bluetooth is powered off")
        case .unsupported:
            throw ForbiddenActionError.unsupportedAction(reason: "Unsupported", description: "Bluetooth is not supported on your Device")
        case .unauthorized:
            throw ForbiddenActionError.missingAuthorization(reason: "Missing authorization", description: "The app needs to be authorized to use Bluetooth. You can do so by going to settings")
        case .poweredOn:
            print("start scanning with options: \(String(describing: options))")
            self.manager.scanForPeripherals(withServices: options?.services, options: options?.options)
            for peripheral in self.connectedDevices {
                self.execute(Array(self.onDiscover.values), for: peripheral)
            }
        @unknown default:
            print("unknown state with rawValue: \(self.manager.state.rawValue)")
        }
    }
    
    public func stopScan() {
        print("stop scanning")
        self.manager.stopScan()
    }
    
    func connect(to device: BluetoothDevice, with options: BluetoothConnectionOptions) {
        if device.state != .connected {
            self.manager.connect(device.peripheral, options: options.options)
        }
    }
    
    func disconnect(from device: BluetoothDevice) {
        self.manager.cancelPeripheralConnection(device.peripheral)
    }
    
    // MARK: - Event Functions
    
    func onConnect(_ owner: NSObject, action: @escaping (BluetoothDevice) -> ()) {
        self.onConnect[owner] = action
    }
    func removeOnConnect(_ owner: NSObject) {
        self.onConnect.removeValue(forKey: owner)
    }
    
    func onFailedConnect(_ owner: NSObject, action: @escaping (BluetoothDevice) -> ()) {
        self.onFailedConnect[owner] = action
    }
    func removeOnFailedConnect(_ owner: NSObject) {
        self.onFailedConnect.removeValue(forKey: owner)
    }
    
    func onDisconnect(_ owner: NSObject, action: @escaping (BluetoothDevice) -> ()) {
        self.onDisconnect[owner] = action
    }
    func removeOnDisconnect(_ owner: NSObject) {
        self.onDisconnect.removeValue(forKey: owner)
    }
    
    func onDiscover(_ owner: NSObject, action: @escaping (BluetoothDevice) -> ()) {
        self.onDiscover[owner] = action
    }
    func removeOnDiscover(_ owner: NSObject) {
        self.onDiscover.removeValue(forKey: owner)
    }
    
    func onStateUpdate(_ owner: NSObject, action: @escaping (BLEManagerProtocol) -> ()) {
        self.onStateUpdate[owner] = action
    }
    func removeOnStateUpdate(_ owner: NSObject) {
        self.onStateUpdate.removeValue(forKey: owner)
    }
    
    // MARK: - Delegate Methods
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var state: String
        switch central.state {
        case .unknown:
            state = "unknown"
            break
        case .resetting:
            state = "resetting"
            break
        case .unsupported:
            state = "unsupported"
            break
        case .unauthorized:
            state = "unauthorized"
            break
        case .poweredOff:
            state = "powered off"
            break
        case .poweredOn:
            state = "powered on"
            break
        @unknown default:
            fatalError("unknown state")
        }
        print("bluetooth manager state is \(state)")
        for closure in self.onStateUpdate.values {
            closure(self)
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        let device: BluetoothDevice = self.getDevice(from: peripheral)
        self.connectedDevices.append(device)
        self.availableDevices.removeAll { $0.peripheral == peripheral }
        device.state = ConnectionState(rawValue: peripheral.state.rawValue) ?? .connecting
        self.execute(Array(self.onConnect.values), for: device)
    }
    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        let device: BluetoothDevice = self.getDevice(from: peripheral)
        device.state = ConnectionState(rawValue: peripheral.state.rawValue) ?? .connecting
        self.execute(Array(self.onFailedConnect.values), for: device)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        let device: BluetoothDevice = self.getDevice(from: peripheral)
        device.state = ConnectionState(rawValue: peripheral.state.rawValue) ?? .connecting
        
        self.connectedDevices.removeAll { $0 == device }
        self.execute(Array(self.onDisconnect.values), for: device)
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        let device: BluetoothDevice = self.getDevice(from: peripheral)
        if !self.availableDevices.contains(device) {
            self.availableDevices.append(device)
        }
        self.execute(Array(self.onDiscover.values), for: device)
    }
    
    // MARK: - Helper Methods
    
    private func execute(_ closures: [(BluetoothDevice) -> ()], for peripheral: BluetoothDevice) {
        for closure in closures {
            closure(peripheral)
        }
    }
    
    private func getDevice(from peripheral: CBPeripheral) -> BluetoothDevice {
        self.connectedDevices.first { $0.peripheral == peripheral } ?? self.availableDevices.first { $0.peripheral == peripheral } ?? BluetoothDevice(peripheral: peripheral)
    }
}
