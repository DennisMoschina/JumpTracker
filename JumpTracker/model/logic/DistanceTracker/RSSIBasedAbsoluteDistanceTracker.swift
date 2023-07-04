//
//  RSSIBasedAbsoluteDistanceTracker.swift
//  FitnessHeadTracker
//
//  Created by Dennis Moschina on 12.12.22.
//

import Foundation
import Combine

class RSSIBasedAbsoluteDistanceTracker: NSObject, AbsoluteDistanceTrackerProtocol {
    private var txPower: Double = -59
    private var timer: Timer?
    
    var _distance: CurrentValueSubject<AbsoluteDistance, Never> = CurrentValueSubject(AbsoluteDistance.zero)
    
    private var device: Device
    
    private var rssiCancellable: AnyCancellable?
    private var sampleRate: Double
    
    init(device: Device, sampleRate: Double = 24) {
        self.device = device
        self.sampleRate = sampleRate
        
        super.init()
        
        self.rssiCancellable = self.device._rssi.sink { rssi in
            self.distance = self.rssiToDistance(rssi: rssi)
        }
    }
    
    func start() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1 / self.sampleRate, repeats: true) { _ in
            self.device.updateRSSI()
        }
    }
    
    func stop() {
        self.timer?.invalidate()
    }
    
    private func rssiToDistance(rssi: Double) -> AbsoluteDistance {
        let ratio = rssi / txPower
        var distance: Double
        
        if (ratio < 1.0) {
            distance = pow(ratio, 10);
        } else {
            distance = 0.89976 * pow(ratio, 7.7095) + 0.111;
        }
        
        return AbsoluteDistance(distance: distance)
    }
}
