//
//  ConnectionScanner.swift
//  Smart Rope
//
//  Created by Dennis Moschina on 04.01.22.
//

import Combine

/**
 * This interface describes a scanner for available connections to devices.
 * - Author: Dennis Moschina
 * - Version: 1.0
 */
protocol ConnectionScanner {
    associatedtype D: Device
    associatedtype O: ScanningOptions
    
    /// The scanner is currently scanning
    var scanning: Bool { get }
    
    /// A List of Devices which can be connected to.
    var availableDevices: [D] { get set }
    var _availableDevices: CurrentValueSubject<[D], Never> { get }
    
    /**
     * Start scanning for available connections.
     * - parameter options: the options with which the scan should perform
     * - throws: scanning failed
     */
    func scan(with options: O?) throws
    /**
     * Stop scanning for available connections.
     */
    func stopScanning()
}
