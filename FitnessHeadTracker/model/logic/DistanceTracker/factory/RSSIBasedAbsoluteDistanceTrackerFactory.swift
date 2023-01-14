//
//  RSSIBasedAbsoluteDistanceTrackerFactory.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 13.12.22.
//

import Foundation

class RSSIBasedAbsoluteDistanceTrackerFactory: NSObject, AbsoluteDistanceTrackerFactory {
    private var bleManager: BLEManagerProtocol
    
    init(bleManager: BLEManagerProtocol) {
        self.bleManager = bleManager
    }
    
    func create() async -> Result<RSSIBasedAbsoluteDistanceTracker, Error> {
        self.bleManager.onDiscover(self) { device in
            if self.checkIfSuitable(device: device) {
                print("found AirPods")
                self.bleManager.connect(to: device, with: BluetoothConnectionOptions(options: nil))
            }
        }
        
        var connectedDevice: BluetoothDevice? = nil
        self.bleManager.onConnect(self) { device in
            if self.checkIfSuitable(device: device) {
                connectedDevice = device
                print("connected to airpods")
                self.bleManager.removeOnDiscover(self)
                self.bleManager.removeOnConnect(self)
            }
        }
        
        #warning("TODO: use callback instead of while")
        while (self.bleManager.state != .poweredOn) {
            await Task.yield()
        }
         
        do {
            try self.bleManager.scan(with: nil)
        } catch {
            print("can't scan due to \(error)")
        }
        
        while (connectedDevice == nil) {
            await Task.yield()
        }
        
        if let connectedDevice {
            return Result.success(RSSIBasedAbsoluteDistanceTracker(device: connectedDevice))
        }
        
        return Result.failure("Timeout" as! Error)
    }
    
    private func checkIfSuitable(device: BluetoothDevice) -> Bool {
        return device.name == "AirPods Pro von Dennis"
    }
}
