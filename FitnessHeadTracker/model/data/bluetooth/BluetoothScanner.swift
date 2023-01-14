//
//  BluetoothScanner.swift
//  Smart Rope
//
//  Created by Dennis Moschina on 04.01.22.
//

import Combine
import CoreBluetooth

/**
 * This class describes a scanner for available Bluetooth Devices.
 * - Version: 1.0
 */
class BluetoothScanner: NSObject, ObservableObject, ConnectionScanner {
    var scanning: Bool {
        self.bleManager.isScanning
    }
    
    var availableDevices: [BluetoothDevice] {
        get {
            self._availableDevices.value
        }
        set {
            self._availableDevices.value = newValue
        }
    }
    var _availableDevices: CurrentValueSubject<[BluetoothDevice], Never> = CurrentValueSubject([])
    
    private var bleManager: BLEManagerProtocol
    
    init(bleManager: BLEManagerProtocol = BLEManager.Singleton) {
        self.bleManager = bleManager
        super.init()
        self.bleManager.onStateUpdate(self, action: self.didUpdateState(manager:))
        
        self.bleManager.onDisconnect(self, action: { peripheral in
            self.availableDevices.removeAll { device in
                device.peripheral == peripheral
            }
        })
    }
    
    deinit {
        self.bleManager.removeOnStateUpdate(self)
        self.bleManager.removeOnDisconnect(self)
    }
    
    func scan(with options: BluetoothScanningOptions?) throws {
        try self.bleManager.scan(with: options)
        self.bleManager.onDiscover(self, action: self.didDiscover(device:))
    }
    
    func stopScanning() {
        self.bleManager.stopScan()
        self.bleManager.removeOnDiscover(self)
    }
    
    
    //MARK: - Delegate Methods
    
    private func didUpdateState(manager: BLEManagerProtocol) {
        if manager.state == .poweredOn {
            do {
                try self.scan(with: nil)
            } catch is ForbiddenActionError {
                print("unable to scan")
            } catch {
                fatalError("somehow failed")
            }
        }
    }
    
    private func didDiscover(device: BluetoothDevice) {
        self.availableDevices = self.bleManager.availableDevices
    }
}
