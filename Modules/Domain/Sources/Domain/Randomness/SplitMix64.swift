//
//  File.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Foundation

/// A small, fast, seedable random number generator.
///
/// A value type, so a session that holds one is reproducible from its seed
/// and can be copied or compared like any other state.
///
/// See Steele, Lea & Flood, "Fast Splittable Pseudorandom Number Generators".
public struct SplitMix64: RandomNumberGenerator, Equatable, Sendable {

    private var state: UInt64

    public init(seed: UInt64) {
        state = seed
    }

    public mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58_476D_1CE4_E5B9
        z = (z ^ (z >> 27)) &* 0x94D0_49BB_1331_11EB
        return z ^ (z >> 31)
    }
}
