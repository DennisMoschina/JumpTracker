//
//  Connector.swift
//  Smart Rope
//
//  Created by Dennis Moschina on 28.12.21.
//

import Foundation
import Combine

/**
 * This interface describes a Manager for connecting Devices.
 *
 * - Author: Dennis Moschina
 * - Version: 1.0
 */
protocol Connector {
    associatedtype D: Device
    associatedtype O: ConnectionOptions
    
    var connectedDevices: [D] { get set }
    var _connectedDevices: CurrentValueSubject<[D], Never> { get }
    
    /**
     * Connect to a devie.
     * - parameters:
     *      - device: the device to connect to
     *      - options: the options for the connection to the device
     */
    func connect(to device: D, with options: O)
    /**
     * Connect to a devie.
     * - parameter device: the device to connect to
     */
    func connect(to device: D)
    /**
     * Disconnect from a device.
     * - parameter device: the device to disconnect from
     */
    func disconnect(from device: D)
}
