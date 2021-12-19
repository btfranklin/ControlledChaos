//  Created by B.T. Franklin on 1/4/19

import Foundation

extension Bool {
    
    /**
    Returns a randomly-generated boolean value with a value that has the provided probability of being "true", where 0 means
    always false, 100 means always true, and 50 means an equal chance of being true or false.
    */
    public static func random(probability: Int) -> Bool {
        guard (0...100).contains(probability) else {
            fatalError("Random boolean probability must be in the range 0 - 100")
        }

        if probability == 0 {
            return false
        } else {
            return Int.random(in: 1...100) <= probability
        }
    }
}
