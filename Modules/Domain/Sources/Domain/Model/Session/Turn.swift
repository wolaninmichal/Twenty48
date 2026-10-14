//
//  Turn.swift
//  Domain
//
//  Created by Michał Wolanin on 28/09/2026.
//

import Foundation

/// What one intent did to the board, for whoever draws it.
///
/// Everything else can be read off the game itself; a turn carries only what
/// the board alone no longer shows.
public struct Turn: Equatable, Sendable {

    /// The merges of the move, whose sources are no longer on the board.
    public let merges: [Merge]

    /// The tiles that appeared after the move, or on a new board.
    public let spawned: [PlacedTile]

    static let none = Turn(merges: [], spawned: [])
}
