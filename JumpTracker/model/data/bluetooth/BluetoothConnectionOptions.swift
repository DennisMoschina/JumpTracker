//
//  BluetoothConnectionOptions.swift
//  Smart Rope
//
//  Created by Dennis Moschina on 28.12.21.
//

import Foundation
import CoreBluetooth

/**
 * This struct wrappes options for connecting to Bluetooth Devices.
 *
 * - Author: Dennis Moschina
 * - Version: 1.0
 */
struct BluetoothConnectionOptions: ConnectionOptions {
    let options: [String: Any]?
}
