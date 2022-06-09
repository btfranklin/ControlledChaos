//  Created by B.T. Franklin on 11/9/16.

#if !os(watchOS)

import XCTest
@testable import ControlledChaos

final class ProbabilityGroupTests: XCTestCase {
    
    func testInitializer() {
        
        let oneGroup = ProbabilityGroup([
            "One":100
        ])
        XCTAssertNotNil(oneGroup)
        
        let twoGroup = ProbabilityGroup([
            "One":50,
            "Two":50
        ])
        XCTAssertNotNil(twoGroup)
        
        let fourGroup = ProbabilityGroup([
            "One":25,
            "Two":25,
            "Three":25,
            "Four":25
        ])
        XCTAssertNotNil(fourGroup)
        
        let nonHundredGroup = ProbabilityGroup([
            "One":45,
            "Two":35,
            "Three":17,
            "Four":82
            ], enforcePercent: false)
        XCTAssertNotNil(nonHundredGroup)
    }
    
    func testSelectOnlyItem() {
        
        let testItem = "Test"
        
        let testGroup = ProbabilityGroup([
            testItem:100
        ])
        
        let testResultItem = testGroup.randomItem()
        XCTAssertNotNil(testResultItem)
        XCTAssertEqual(testItem, testResultItem)
    }
    
    func testRandomItem() {
        
        let itemDictionary = [
            "One":25,
            "Two":25,
            "Three":50
        ]
        
        let testGroup = ProbabilityGroup(itemDictionary)
        let itemNames = Set(itemDictionary.keys)
        
        let testResultItem = testGroup.randomItem()
        XCTAssertNotNil(testResultItem)
        XCTAssert(itemNames.contains(testResultItem))
    }

    func testRandomItemsWithSeededRNG() {

        let itemDictionary = [
            "One":25,
            "Two":25,
            "Three":25,
            "Four":25
        ]

        let testGroup = ProbabilityGroup(itemDictionary)
        let itemNames = Set(itemDictionary.keys)

        let seedState = UInt64.random(in: UInt64.min...UInt64.max)
        var seededRNG = SeededRandomNumberGenerator(state: seedState)
        var resultList1: [String] = []
        for _ in 1...50 {
            let testResultItem = testGroup.randomItem(using: &seededRNG)
            XCTAssertNotNil(testResultItem)
            XCTAssert(itemNames.contains(testResultItem))
            resultList1.append(testResultItem)
        }

        seededRNG = SeededRandomNumberGenerator(state: seedState)
        var resultList2: [String] = []
        for _ in 1...50 {
            let testResultItem = testGroup.randomItem(using: &seededRNG)
            XCTAssertNotNil(testResultItem)
            XCTAssert(itemNames.contains(testResultItem))
            resultList2.append(testResultItem)
        }

        XCTAssertEqual(resultList1, resultList2)
    }

    func testHashable() {
        
        let itemDictionary1 = [
            "One":25,
            "Two":25,
            "Three":50
        ]
        let testGroup1 = ProbabilityGroup(itemDictionary1)
        
        let itemDictionary2 = [
            "Four":33,
            "Five":34,
            "Six":33
        ]
        let testGroup2 = ProbabilityGroup(itemDictionary2)
        
        var groupSet = Set<ProbabilityGroup<String>>()
        groupSet.insert(testGroup1)
        groupSet.insert(testGroup2)
        
        XCTAssert(groupSet.contains(testGroup1))
        XCTAssert(groupSet.contains(testGroup2))
    }

    func testEquatable() {
        
        let itemDictionary1 = [
            "One":25,
            "Two":25,
            "Three":50
        ]
        let testGroup1 = ProbabilityGroup(itemDictionary1)
        
        let itemDictionary2 = [
            "Four":33,
            "Five":34,
            "Six":33
        ]
        let testGroup2 = ProbabilityGroup(itemDictionary2)
        let testGroup3 = ProbabilityGroup(itemDictionary2)
        
        XCTAssertNotEqual(testGroup1, testGroup2)
        XCTAssertNotEqual(testGroup1, testGroup3)
        XCTAssertEqual(testGroup2, testGroup3)
    }
    
    func testCodable() {
        let itemDictionary = [
            "One":10,
            "Two":10,
            "Three":10,
            "Four":10,
            "Five":10,
            "Six":10,
            "Seven":10,
            "Eight":10,
            "Nine":10,
            "Ten":10
        ];
        let testGroup = ProbabilityGroup(itemDictionary)
        
        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(testGroup)
        
        let decoder = JSONDecoder()
        let decodedGroup = try! decoder.decode(ProbabilityGroup<String>.self, from: encoded)
        
        let itemNames = Set(itemDictionary.keys)
        let testResultItem = decodedGroup.randomItem()
        XCTAssertNotNil(testResultItem)
        XCTAssert(itemNames.contains(testResultItem))
    }
    
    func testPerformance() {
        
        let itemDictionary = [
            "One":10,
            "Two":10,
            "Three":10,
            "Four":10,
            "Five":10,
            "Six":10,
            "Seven":10,
            "Eight":10,
            "Nine":10,
            "Ten":10
        ];
        let testGroup = ProbabilityGroup(itemDictionary)
        
        self.measure {
            for _ in 1...1000 {
                _ = testGroup.randomItem()
            }
        }
    }
    
}
#endif
