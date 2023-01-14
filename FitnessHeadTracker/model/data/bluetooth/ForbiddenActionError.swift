//
//  ForbiddenActionError.swift
//  Smart Rope
//
//  Created by Dennis Moschina on 06.02.22.
//

import Foundation

/**
 * Error for forbidden actions.
 * - Version: 1.0
 */
enum ForbiddenActionError: Error {
    /// The authorization is missing for an action
    case missingAuthorization(reason: String? = nil, description: String? = nil)
    /// The action is not supported
    case unsupportedAction(reason: String? = nil, description: String? = nil)
    /// The action is not supported in this state
    case wrongState(reason: String? = nil, description: String? = nil)
    
    var reason: String? {
        switch self {
        case .missingAuthorization(reason: let reason, _):
            return reason
        case .unsupportedAction(reason: let reason, _):
            return reason
        case .wrongState(reason: let reason, _):
            return reason
        }
    }
    
    var description: String? {
        switch self {
        case .missingAuthorization(_, description: let description):
            return description
        case .unsupportedAction(_, description: let description):
            return description
        case .wrongState(_, description: let description):
            return description
        }
    }
}
