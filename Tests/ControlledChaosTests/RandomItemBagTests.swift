//  Created by B.T. Franklin on 8/27/19

#if !os(watchOS)

import XCTest
@testable import ControlledChaos

final class RandomItemBagTests: XCTestCase {
    
    func testInitializers() {
        
        let emptyBag = RandomItemBag<String>()
        XCTAssertNotNil(emptyBag)

        let oneItemBag = RandomItemBag([
            "One":25
        ])
        XCTAssertNotNil(oneItemBag)
        
        let twoItemBag = RandomItemBag([
            "One":25,
            "Two":25
        ])
        XCTAssertNotNil(twoItemBag)
        
        let fourItemGroup = RandomItemBag([
            "One":45,
            "Two":35,
            "Three":17,
            "Four":82
        ])
        XCTAssertNotNil(fourItemGroup)
    }
    
    func testRandomItem() {
        
        let testBag = RandomItemBag<String>()
        XCTAssertNil(testBag.randomItem())
        
        let itemNames = [
            "One",
            "Two",
            "Three",
            "Four",
            "Five"
        ]
        for itemName in itemNames {
            testBag.add(itemName, withCount: 37)
        }
        
        for _ in 1...1000 {
            let testResultItem = testBag.randomItem()!
            XCTAssertNotNil(testResultItem)
            XCTAssert(itemNames.contains(testResultItem))
        }
    }
    
    func testRemoveAll() {
        
        let testBag = RandomItemBag<String>()
        
        var itemNames = [
            "One",
            "Two",
            "Three",
            "Four",
            "Five"
        ]
        for itemName in itemNames {
            testBag.add(itemName, withCount: 37)
        }

        testBag.removeAll(itemNames.remove(at: 0))
        testBag.removeAll(itemNames.remove(at: itemNames.count-1))
        
        for _ in 1...1000 {
            let testResultItem = testBag.randomItem()!
            XCTAssertNotNil(testResultItem)
            XCTAssert(itemNames.contains(testResultItem))
        }
    }
    
    func testHashable() {
        
        let itemDictionary1 = [
            "One":25,
            "Two":25,
            "Three":25
        ]
        let testBag1 = RandomItemBag(itemDictionary1)
        
        let itemDictionary2 = [
            "Four":30,
            "Five":15,
            "Six":25
        ]
        let testBag2 = RandomItemBag(itemDictionary2)
        
        var bagSet = Set<RandomItemBag<String>>()
        bagSet.insert(testBag1)
        bagSet.insert(testBag2)
        
        XCTAssert(bagSet.contains(testBag1))
        XCTAssert(bagSet.contains(testBag2))
    }

    func testEquatable() {
        
        let itemDictionary1 = [
            "One":25,
            "Two":25,
            "Three":25
        ]
        let testBag1 = RandomItemBag(itemDictionary1)
        
        let itemDictionary2 = [
            "Four":30,
            "Five":15,
            "Six":25
        ]
        let testBag2 = RandomItemBag(itemDictionary2)
        let testBag3 = RandomItemBag(itemDictionary2)
        
        XCTAssertNotEqual(testBag1, testBag2)
        XCTAssertNotEqual(testBag1, testBag3)
        XCTAssertEqual(testBag2, testBag3)
    }
    
    func testCodable() {
        let testBag = RandomItemBag<String>()
        
        let itemNames = [
            "One",
            "Two",
            "Three",
            "Four",
            "Five"
        ]
        for itemName in itemNames {
            testBag.add(itemName, withCount: 37)
        }

        let encoder = JSONEncoder()
        let encoded = try! encoder.encode(testBag)
        
        let jsonString = NSString(data: encoded, encoding: String.Encoding.utf8.rawValue)!
        print(jsonString)
        
        let decoder = JSONDecoder()
        let decodedBag = try! decoder.decode(RandomItemBag<String>.self, from: encoded)
        
        let testResultItem = decodedBag.randomItem()!
        XCTAssertNotNil(testResultItem)
        XCTAssert(itemNames.contains(testResultItem))
    }

    func testPerformance() {
        
        let testBag = RandomItemBag<String>()
        testBag.add("One", withCount: 20)
        testBag.add("Two", withCount: 20)
        testBag.add("Three", withCount: 20)
        testBag.add("Four", withCount: 20)
        testBag.add("Five", withCount: 20)
        
        self.measure {
            for _ in 1...1000 {
                _ = testBag.randomItem()
            }
        }
    }
    
}
#endif
