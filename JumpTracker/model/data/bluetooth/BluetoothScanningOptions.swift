//
//  BluetoothScanningOptions.swift
//  Smart Rope
//
//  Created by Dennis Moschina on 04.01.22.
//

import Foundation
import CoreBluetooth

struct BluetoothScanningOptions: ScanningOptions {
    let services: [CBUUID]?
    let options: [String : Any]?
}
