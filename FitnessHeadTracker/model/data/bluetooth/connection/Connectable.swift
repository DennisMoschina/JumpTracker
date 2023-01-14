//
//  Connectable.swift
//  Smart Rope
//
//  Created by Dennis Moschina on 14.12.21.
//

import Foundation

protocol Connectable {
    var state: ConnectionState { get }
    
    func connect()
    func disconnect()
}
