//  Created by B.T. Franklin on 1/4/19

import Foundation

extension Bool {

    /**
     Returns a randomly-generated boolean value with a value that has the provided probability of being "true", where 0.0 means
     always false, 1.0 means always true, and 0.5 means an equal chance of being true or false. The random value will be produced
     using the provided `RandomNumberGenerator`.
     */
    public static func random<G: RandomNumberGenerator>(probability: Double, using generator: inout G) -> Bool {
        guard (0.0...1.0).contains(probability) else {
            fatalError("Random boolean probability must be in the range 0.0 - 1.0")
        }

        if probability == 0 {
            return false
        } else {
            return Double.random(in: 0.0...1.0, using: &generator) <= probability
        }
    }
    
    /**
     Returns a randomly-generated boolean value with a value that has the provided probability of being "true", where 0.0 means
     always false, 1.0 means always true, and 0.5 means an equal chance of being true or false.
     */
    public static func random(probability: Double) -> Bool {
        var systemRandomNumberGenerator = SystemRandomNumberGenerator()
        return random(probability: probability, using: &systemRandomNumberGenerator)
    }

}
