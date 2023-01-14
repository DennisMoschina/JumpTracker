//
//  DataReceiver.swift
//  Smart Rope
//
//  Created by Dennis Moschina on 29.01.22.
//

import Foundation

/**
 * Used to read Data.
 * - Version: 1.0
 */
protocol DataReceiver {
    /**
     * The data.
     * - warning: has to be read by readData() first
     */
    var data: Data? { get set }
    
    /**
     * Reads the data and puts the value in data
     */
    func readData()
}
