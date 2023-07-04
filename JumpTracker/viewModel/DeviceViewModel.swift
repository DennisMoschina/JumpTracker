//
//  DeviceViewModel.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 12.12.22.
//

import Foundation
import Combine

class DeviceViewModel: ObservableObject {
    @Published var name: String
    @Published var state: ConnectionState
    @Published var rssi: Double
    
    private var device: Device
    
    
    init(device: Device) {
        self.device = device
        self.name = device.name ?? "N/A"
        self.state = device.state
        self.rssi = device.rssi
    }
}
