//  Created by B.T. Franklin on 6/8/22

#if !os(watchOS)

import XCTest
@testable import ControlledChaos

final class SeededRandomNumberGeneratorTests: XCTestCase {

    func testSeedStateInitialization() {
        let seedState = UInt64.random(in: UInt64.min...UInt64.max)
        var seededRNG = SeededRandomNumberGenerator(state: seedState)
        var resultList1: [UInt64] = []
        for _ in 1...50 {
            let testResultItem = seededRNG.next()
            resultList1.append(testResultItem)
        }

        seededRNG = SeededRandomNumberGenerator(state: seedState)
        var resultList2: [UInt64] = []
        for _ in 1...50 {
            let testResultItem = seededRNG.next()
            resultList2.append(testResultItem)
        }

        XCTAssertEqual(resultList1, resultList2)
    }

    func testPerformance() {

        let seedState = UInt64.random(in: UInt64.min...UInt64.max)
        var seededRNG = SeededRandomNumberGenerator(state: seedState)

        self.measure {
            for _ in 1...1000 {
                _ = seededRNG.next()
            }
        }
    }

}
#endif
