//
//  Util.swift
//  JumpTracker
//
//  Created by Dennis Moschina on 08.07.23.
//

import Foundation
import AVFoundation

func toggleTorch(on: Bool) {
    guard let device = AVCaptureDevice.default(for: .video) else { return }

    if device.hasTorch {
        do {
            try device.lockForConfiguration()

            if on == true {
                device.torchMode = .on
            } else {
                device.torchMode = .off
            }

            device.unlockForConfiguration()
        } catch {
            print("Torch could not be used")
        }
    } else {
        print("Torch is not available")
    }
}

func extractVerticalHipPosition(from recording: Recording) -> [Double]? {
    guard let hipPositions: NSOrderedSet = recording.hipPositions else {
        fatalError()
        return nil
    }
    guard hipPositions.count > 0 else { return nil; fatalError() }
    
    return hipPositions.compactMap {
        if let f = ($0 as? CDPosition)?.y {
            return Double(f)
        } else { return nil; fatalError() }
    }
}

func extractVerticalAcceleration(from recording: Recording) -> [Double] {
    guard let motions: NSOrderedSet = recording.motions else {
        fatalError()
    }
    guard motions.count > 0 else { fatalError() }
    
    return motions.map {
        if let f = ($0 as? CDMotion)?.userAcceleration?.z {
            return Double(f)
        } else {
            fatalError()
        }
    }
}
