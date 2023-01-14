//
//  BLEManagerProtocol.swift
//  Smart Rope
//
//  Created by Dennis Moschina on 02.02.22.
//

import Foundation

protocol BLEManagerProtocol {
    static var Singleton: BLEManagerProtocol { get }
    
    var isScanning: Bool { get }
    var state: BLEManagerState { get }
    
    var availableDevices: [BluetoothDevice] { get }
    var connectedDevices: [BluetoothDevice] { get }
    
    func scan(with options: BluetoothScanningOptions?) throws
    func stopScan()
    
    func connect(to peripheral: BluetoothDevice, with options: BluetoothConnectionOptions)
    func disconnect(from peripheral: BluetoothDevice)
    
    func onConnect(_ owner: NSObject, action: @escaping (BluetoothDevice) -> ())
    func removeOnConnect(_ owner: NSObject)
    
    func onFailedConnect(_ owner: NSObject, action: @escaping (BluetoothDevice) -> ())
    func removeOnFailedConnect(_ owner: NSObject)
    
    func onDisconnect(_ owner: NSObject, action: @escaping (BluetoothDevice) -> ())
    func removeOnDisconnect(_ owner: NSObject)
    
    func onDiscover(_ owner: NSObject, action: @escaping (BluetoothDevice) -> ())
    func removeOnDiscover(_ owner: NSObject)
    
    func onStateUpdate(_ owner: NSObject, action: @escaping (BLEManagerProtocol) -> ())
    func removeOnStateUpdate(_ owner: NSObject)
}
