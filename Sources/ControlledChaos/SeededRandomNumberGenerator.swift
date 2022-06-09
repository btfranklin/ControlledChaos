//  Created by B.T. Franklin on 6/5/22

import Foundation

// This is a stateful pseudorandom number generator using an implementation of the SplitMix64 algorithm,
// which was written by Sebastiano Vigna and placed in the public domain. His original source code
// can be found at: http://xorshift.di.unimi.it/splitmix64.c
public struct SeededRandomNumberGenerator: RandomNumberGenerator {

    public private(set) var state: UInt64

    public init(state: UInt64) {
        self.state = state
    }

    public mutating func next() -> UInt64 {
        state &+= 0x9e3779b97f4a7c15
        var z = state
        z = (z ^ (z &>> 30)) &* 0xbf58476d1ce4e5b9
        z = (z ^ (z &>> 27)) &* 0x94d049bb133111eb
        return z ^ (z &>> 31)
    }
}
