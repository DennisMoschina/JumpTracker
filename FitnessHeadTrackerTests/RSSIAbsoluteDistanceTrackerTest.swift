//
//  RSSIAbsoluteDistanceTrackerTest.swift
//  FitnessHeadTrackerTests
//
//  Created by Dennis Moschina on 15.12.22.
//

import XCTest
@testable import FitnessHeadTracker

final class RSSIAbsoluteDistanceTrackerTest: XCTestCase {
    
    var device: Device?
    var distanceTracker: RSSIBasedAbsoluteDistanceTracker?

    override func setUpWithError() throws {
        self.device = DeviceMock(name: "Mock", state: .connected)
        self.distanceTracker = RSSIBasedAbsoluteDistanceTracker(device: self.device!, sampleRate: 1)
    }

    override func tearDownWithError() throws {
        self.device = nil
        self.distanceTracker?.stop()
        self.distanceTracker = nil
    }

    func testUpdateRSSI() async throws {
        self.distanceTracker?.start()
        
        try await Task.sleep(for: Duration.seconds(5))
        
        XCTAssertEqual(50, self.device!.rssi, accuracy: 0.1)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
