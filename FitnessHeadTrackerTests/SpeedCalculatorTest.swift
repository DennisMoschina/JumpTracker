//
//  SpeedCalculatorTest.swift
//  FitnessHeadTrackerTests
//
//  Created by Dennis Moschina on 31.10.22.
//

import XCTest
@testable import FitnessHeadTracker


final class SpeedCalculatorTest: XCTestCase {
    
    var speedCalculator: (any SpeedCalculatorProtocol)?
    var motionManagerMock: MotionManagerMock?

    override func setUpWithError() throws {
        self.motionManagerMock = MotionManagerMock()
        self.speedCalculator = MotionBasedSpeedCalculator(motionManager: self.motionManagerMock!)
        
        self.motionManagerMock?.start()
    }

    override func tearDownWithError() throws {
        self.motionManagerMock?.stop()
    }

    func testCalculateSpeedLinear() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        
        self.assertSpeedEqual(SIMDSpeed.zero, self.speedCalculator!.speed)
        
        for _ in 0..<5 {
            self.motionManagerMock?.update(acceleration: SIMDAcceleration(x: 0.3))
        }
        
        self.assertSpeedEqual(SIMDSpeed(x: 0.15), self.speedCalculator!.speed)
    }
    
    func testCalculateSpeedDiscrete() throws {
        self.assertSpeedEqual(SIMDSpeed.zero, self.speedCalculator!.speed)
        
        self.motionManagerMock?.update(acceleration: SIMDAcceleration(x: 0.1))
        self.motionManagerMock?.update(acceleration: SIMDAcceleration(x: 0.3))
        self.motionManagerMock?.update(acceleration: SIMDAcceleration(x: 0.1))
        self.motionManagerMock?.update(acceleration: SIMDAcceleration(x: -0.05))
        self.motionManagerMock?.update(acceleration: SIMDAcceleration(x: 0.2))
        
        self.assertSpeedEqual(SIMDSpeed(x: 0.065), self.speedCalculator!.speed)
    }
    
    func testCalculateSpeedWithSmallInterval() throws {
        self.assertSpeedEqual(SIMDSpeed.zero, self.speedCalculator!.speed)
        
        for _ in 0..<100 {
            self.motionManagerMock?.update(acceleration: SIMDAcceleration(x: 0.3), timeInterval: 0.01)
        }
        
        let speed: any Speed = self.speedCalculator!.speed
        
        self.assertSpeedEqual(SIMDSpeed(x: 0.3), speed)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

    
    private func assertSpeedEqual(_ lhs: any Speed, _ rhs: any Speed) {
        XCTAssertEqual(lhs.x, rhs.x, accuracy: 0.001)
        XCTAssertEqual(lhs.y, rhs.y, accuracy: 0.001)
        XCTAssertEqual(lhs.z, rhs.z, accuracy: 0.001)
    }
}
