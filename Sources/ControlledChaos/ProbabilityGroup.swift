//  Created by B.T. Franklin on an unknown date prior to 2020

import Foundation

public struct ProbabilityGroup<Item: Hashable & Codable>: Hashable {
    
    enum CodingKeys: String, CodingKey {
        case probabilitiesByItem = "probabilities"
    }
    
    public let probabilitiesByItem: [Item: Int]
    
    private let items: [Item]
    private let itemPositions: [Int]
    private let total: Int
    
    public init(_ probabilitiesByItem: [Item: Int],
                enforcePercent: Bool = true) {

        guard !probabilitiesByItem.isEmpty else {
            fatalError("Must provide at least one item.")
        }
        
        self.probabilitiesByItem = probabilitiesByItem
        
        var currentPosition = 0;
        var items: [Item] = []
        var itemPositions: [Int] = []
        
        for itemProbability in probabilitiesByItem {
            items.append(itemProbability.key)
            itemPositions.append(currentPosition)
            
            currentPosition += itemProbability.value
        }
        
        if enforcePercent {
            assert(currentPosition == 100, "Item probabilities must add up to exactly 100, but provided ones add up to \(currentPosition).")
        }
        
        self.items = items
        self.itemPositions = itemPositions
        self.total = currentPosition
    }
    
    public func randomItem<G: RandomNumberGenerator>(using generator: inout G) -> Item {

        let randomNumber = Int.random(in: 0...total, using: &generator)

        for i in 1..<itemPositions.count {
            if randomNumber < itemPositions[i] {
                return items[i-1]
            }
        }

        return items.last!
    }

    public func randomItem() -> Item {
        var systemRandomNumberGenerator = SystemRandomNumberGenerator()
        return randomItem(using: &systemRandomNumberGenerator)
    }

    public static func copy(_ probabilityGroup: ProbabilityGroup, without item: Item) -> ProbabilityGroup {
        guard probabilityGroup.items.contains(item) else {
            fatalError("ProbabilityGroup does not contain \(item)")
        }

        var probabilitiesByItem = probabilityGroup.probabilitiesByItem
        probabilitiesByItem[item] = nil
        return ProbabilityGroup(probabilitiesByItem, enforcePercent: false)
    }
}

extension ProbabilityGroup: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(probabilitiesByItem, forKey: .probabilitiesByItem)
    }
}

extension ProbabilityGroup: Decodable {
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        let probabilitiesByItem = try values.decode([Item: Int].self, forKey: .probabilitiesByItem)
        self.init(probabilitiesByItem, enforcePercent: false)
    }
}
