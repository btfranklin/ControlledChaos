//  Created by B.T. Franklin on 1/4/19

#if !os(watchOS)

import XCTest
@testable import ControlledChaos

final class BoolRandomProbabilityTests: XCTestCase {

    func testRandomProbability() {

        // 0%
        for _ in 1...1000 {
            let randomBoolean = Bool.random(probability: 0.0)
            XCTAssertFalse(randomBoolean)
        }

        // 20%
        var trueCount = 0
        for _ in 1...1000 {
            let randomBoolean = Bool.random(probability: 0.2)
            if randomBoolean {
                trueCount += 1
            }
        }
        XCTAssertTrue((150...250).contains(trueCount), "trueCount was \(trueCount)")

        // 50%
        trueCount = 0
        for _ in 1...1000 {
            let randomBoolean = Bool.random(probability: 0.5)
            if randomBoolean {
                trueCount += 1
            }
        }
        XCTAssertTrue((450...550).contains(trueCount), "trueCount was \(trueCount)")

        // 75%
        trueCount = 0
        for _ in 1...1000 {
            let randomBoolean = Bool.random(probability: 0.75)
            if randomBoolean {
                trueCount += 1
            }
        }
        XCTAssertTrue((700...800).contains(trueCount), "trueCount was \(trueCount)")

        // 100%
        for _ in 1...1000 {
            let randomBoolean = Bool.random(probability: 1.0)
            XCTAssertTrue(randomBoolean)
        }
    }

    func testPerformanceRandomProbability() {
        self.measure {
            for _ in 0...1000 {
                _ = Bool.random(probability: 0.5)
            }
        }
    }
}
#endif
