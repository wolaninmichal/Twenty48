//
//  File.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Foundation

/// The identity of a tile.
///
/// A tile keeps its identity for as long as it stays on the board, sliding
/// included. Two tiles that merge end there; the tile they make is a new one.
public struct TileID: Hashable, Sendable {
    public let rawValue: UInt64

    public init(rawValue: UInt64) {
        self.rawValue = rawValue
    }
}

/// A source of tile identities that never hands out the same one twice.
///
/// A value rather than a global counter, so a session and everything it
/// produces stay reproducible.
struct TileIDGenerator: Equatable, Sendable {
    private var upcoming: UInt64 = 0

    init() {}

    mutating func next() -> TileID {
        defer { upcoming += 1 }
        return TileID(rawValue: upcoming)
    }
}
