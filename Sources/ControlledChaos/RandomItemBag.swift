//  Created by B.T. Franklin on 8/27/19

import Foundation

public class RandomItemBag<Item: Hashable & Codable>: Codable {
    
    enum CodingKeys: String, CodingKey {
        case itemCounts = "itemCounts"
    }

    private var itemCounts: [Item:Int]
    private var items: [Item] = []
    private var calculatedItemGroupPositions: [Int] = []
    private var calculatedItemGroupPositionsValid = false
    
    public var count: Int {
        var countSum = 0
        for itemCount in itemCounts.values {
            countSum += itemCount
        }
        return countSum
    }
    
    public init() {
        self.itemCounts = [:]
    }
    
    public init(_ itemCounts: [Item: Int]) {
        self.itemCounts = itemCounts
    }
    
    private func invalidateCalculatedItemPositions() {
        calculatedItemGroupPositionsValid = false
        items = []
        calculatedItemGroupPositions = []
    }
    
    public func add(_ item: Item, withCount count: Int) {
        itemCounts[item] = count
        invalidateCalculatedItemPositions()
    }
    
    public func removeAll(_ item: Item) {
        itemCounts.removeValue(forKey: item)
        invalidateCalculatedItemPositions()
    }
    
    public func randomItem(using generator: inout some RandomNumberGenerator) -> Item? {
        if itemCounts.isEmpty {
            return nil
        }
        
        if !calculatedItemGroupPositionsValid {
            var currentPosition = 0;
            for itemCountEntry in itemCounts {
                items.append(itemCountEntry.key)
                calculatedItemGroupPositions.append(currentPosition)
                
                currentPosition += itemCountEntry.value
            }
            
            calculatedItemGroupPositionsValid = true
        }
        
        let randomNumber = Int.random(in: 0...count, using: &generator)
        
        for i in 1..<calculatedItemGroupPositions.count {
            if randomNumber < calculatedItemGroupPositions[i] {
                return items[i-1]
            }
        }
        
        return items.last!
    }

    public func randomItem() -> Item? {
        var systemRandomNumberGenerator = SystemRandomNumberGenerator()
        return randomItem(using: &systemRandomNumberGenerator)
    }

    // MARK: Codable Implementation
    required public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let itemCounts = try values.decode([Item: Int].self, forKey: .itemCounts)
        self.itemCounts = itemCounts
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(itemCounts, forKey: .itemCounts)
    }

}

extension RandomItemBag: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.itemCounts)
    }
}

extension RandomItemBag: Equatable {
    public static func == (lhs: RandomItemBag<Item>, rhs: RandomItemBag<Item>) -> Bool {
        return lhs.itemCounts == rhs.itemCounts
    }
}
